## What's this gem do

preload ActiveRecord Associations when using graphql and ActiveRecord

## Install

`gem rgraphql_preload_ar`


## How to use

#### Scene

Your original code of resolver might look like this: 

```ruby
class Resolvers::ProfileResolver < GraphQL::Function
  description 'User profile'

  type Types::ProfileType

  def _call(_, args, ctx)
    ctx[:current_user]
  end
end
```

If the query like this:
```
query{
  profile{
    id
    works{
      comments{
        replyUser{
          name
        }
        content
      }
      name
      id
      likes{
        owner{
          name
          works{
            name
            likes{
              owner{
                name
              }
            }
          }
        }
      }
    }
    name
  }
}
```

It will cause Multi-level nested N + 1 problem.

And you want to resolver it, you can write like this:

```ruby
class Resolvers::ProfileResolver < OptimizedFunction
  description 'User profile'

  type Types::ProfileType

  def _call(_, args, ctx)
    User.includes([works: [comments: :reply_user, likes: [owner: [works: [likes: :owner]]]]]).find(ctx[:current_user].id)
  end
end
```

You will manually resolve N + 1 problem in every resolver.Worse, even if only one field is used, you need to request all the tables included.

#### Usage

Your Resolver inherits from `OptimizedFunction` instead of `GraphQL::Function`.
Defining `_call` method instead of `call`
Using `includes_klass(your_model_name)` instead of your original includes statement.


```ruby
class Resolvers::ProfileResolver < OptimizedFunction
  description 'User profile'

  type Types::ProfileType

  def _call(_, args, ctx)
    includes_kclass(User).find(ctx[:current_user].id)
  end
end
```
