# Elm Simple JSON Decoding

A playground for decoding a JSON object in [elm](http://elm-lang.org/).

One thing that threw me with decoding a JSON response was that you _have to know_ what the response is before you can decode it.

To my knowledge, unlike JavaScript you can't seem to blurt out the complete response of a Http request to a console or whatever - and then decide what parts you need.

It's no biggie. If you're unsure of the structure of your response, try using something like [Postman](https://www.getpostman.com/ "Postman") or [Paw](https://luckymarmot.com/paw "Paw").

The following examples are using the same endpoint yet decoding different levels of data in the responses. I've also included an example on handling a Http.Error.

* [Simple string](http://chrisbuttery.github.io/elm-simple-json-decoding/simple_string.html)
* [Nested object](http://chrisbuttery.github.io/elm-simple-json-decoding/nested_object.html)
* [Nested list](http://chrisbuttery.github.io/elm-simple-json-decoding/nested_list.html)
* [Oddly shaped object](http://chrisbuttery.github.io/elm-simple-json-decoding/oddly_shaped_object.html)
* [Handle Http Error](http://chrisbuttery.github.io/elm-simple-json-decoding/http_error.html)

### Response

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

> [chrisbuttery.com](http://chrisbuttery.com) &nbsp;&middot;&nbsp;
> GitHub [@chrisbuttery](https://github.com/chrisbuttery) &nbsp;&middot;&nbsp;
> Twitter [@buttahz](https://twitter.com/buttahz) &nbsp;&middot;&nbsp;
> elm-lang slack [@butters](http://elmlang.herokuapp.com/)
