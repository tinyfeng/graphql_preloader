## What's this gem do

preload ActiveRecord Associations when using graphql and ActiveRecord

## Install

`gem 'graphql_preloader'`

## Scene

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

And you want to resolve it, you can write like this:

```ruby
class Resolvers::ProfileResolver < GraphQL::Function
  description 'User profile'

  type Types::ProfileType

  def call(_, args, ctx)
    User.includes([works: [comments: :reply_user, likes: [owner: [works: [likes: :owner]]]]]).find(ctx[:current_user].id)
  end
end
```

You will manually resolve N + 1 problem in every resolver.Worse, even if only one field is used, you need to request all the tables included.

## Usage

Your Resolver inherits from `PreloadFunction` instead of `GraphQL::Function`.
Defining `_call` method instead of `call`
Using `included_model(your_model_name)` instead of your original includes statement.


```ruby
class Resolvers::ProfileResolver < PreloadFunction
  description 'User profile'

  type Types::ProfileType

  def _call(_, args, ctx)
    included_model(User).find(ctx[:current_user].id)
  end
end
```
