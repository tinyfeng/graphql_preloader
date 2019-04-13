require 'graphql'
class OptimizedFunction < GraphQL::Function
  def call(obj, args, ctx)
    @ctx = ctx
    @json_tree = {}
    @result_tree = {}
    _call obj, args, ctx
  end

  def includes_kclass klass
    @init_klass = klass
    recursion query_tree
    gen_result_tree klass
    klass.includes @result_tree
  end

  def query_tree
    @ctx.query.document.children.first.selections.first
  end

  def recursion node, tree = @json_tree
    tree[node.name.underscore.to_sym] = {}
    node.selections.each do |n|
      recursion n, tree[node.name.underscore.to_sym]
    end
  end

  def really_json_tree
    @json_tree.values.first
  end

  def gen_result_tree klass = @init_klass, tree = really_json_tree, result_tree = @result_tree
    tree.each do |k, v|
      if v.present? && klass.reflect_on_all_associations.map(&:name).include?(k)
        result_tree[k.to_sym] = {}
        next if klass.reflections[k.to_s].options[:polymorphic]
        _klass = klass.reflections[k.to_s].class_name.constantize
        gen_result_tree _klass, tree[k], result_tree[k.to_sym]
      end
    end
  end
end

