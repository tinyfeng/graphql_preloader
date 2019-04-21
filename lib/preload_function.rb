require 'graphql'
class PreloadFunction < GraphQL::Function
  def call obj, args, ctx
    @ctx = ctx
    @json_tree = {}
    @result_tree = {}
    _call obj, args, ctx
  end

  def included_model model_class
    @root_model_class = model_class
    recursion query_tree
    gen_accociations_tree model_class
    model_class.includes @result_tree
  end

  def query_tree
    @ctx.query.document.children.first.selections.first
  end

  def recursion node, tree = @json_tree
    node_key = node.name.underscore.to_sym
    tree[node_key] = {}
    node.selections.each do |n|
      recursion n, tree[node_key]
    end
  end

  def json_tree_without_root
    @json_tree.values.first
  end

  def gen_accociations_tree model_class = @root_model_class, tree = json_tree_without_root, result_tree = @result_tree
    tree.each do |k, v|
      if v.present? && model_class.reflect_on_all_associations.map(&:name).include?(k)
        result_tree[k.to_sym] = {}
        next if model_class.reflections[k.to_s].options[:polymorphic]
        _model_class = model_class.reflections[k.to_s].class_name.constantize
        gen_accociations_tree _model_class, tree[k], result_tree[k.to_sym]
      end
    end
  end
end

