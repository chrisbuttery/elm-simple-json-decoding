# Elm Simple JSON Decoding

A playground of basic examples decoding a JSON object.

* [Simple string](http://chrisbuttery.github.io/elm-simple-json-decoding/simple_string.html)
* [Nested object](http://chrisbuttery.github.io/elm-simple-json-decoding/nested_object.html)
* [Nested list](http://chrisbuttery.github.io/elm-simple-json-decoding/nested_list.html)
* [Oddly shaped object](http://chrisbuttery.github.io/elm-simple-json-decoding/oddly_shaped_object.html)
* [Handle Http Error](http://chrisbuttery.github.io/elm-simple-json-decoding/http_error.html)

### Example data structure

[https://api.myjson.com/bins/yws2](https://api.myjson.com/bins/yws2)

```js
{
  "title": "This is an amazing title",
  "data": [
    {
      "id": 1,
      "name": "foo"
    },
    {
      "id": 2,
      "name": "bar"
    },
    {
      "id": 3,
      "name": "baz"
    }
  ],
  "obj": {
    "title": "I'm a nested object"
  },
  "members": [
    {
      "id": 4,
      "name": "garply",
      "profile": {
        "avatar": "some_path_to_garply"
      }
    },
    {
      "id": 5,
      "name": "waldo",
      "profile": {
        "avatar": "some_path_to_waldo"
      }
    },
    {
      "id": 6,
      "name": "fred",
      "profile": {
        "avatar": "some_path_to_fred"
      }
    }
  ]
}
```
