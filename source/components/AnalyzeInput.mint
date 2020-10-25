component AnalyzeInput {
  property loading : Bool
  property initial = ""
  property value = ""

  property onSubmit : Function(String, Promise(Never, Void))
  property onChange : Function(String, Promise(Never, Void))

  style container {
    background-color: #{Color:GREY};
    width: 100%;
    border: none;
    padding: 1em;
    display: flex;
    justify-content: space-between;

    input {
      outline: none;
      background-color: #{Color:GREY};
      width: 80%;
      border: none;
      color: #{Color:PRIMARY};
      font-size: 1.8em;
      font-family: Poppins, sans-serif;
    }

    button {
      color: #{Color:WHITE};
      background-color: #{Color:BLACK};
      transition: background 400ms;
      border: none;
      cursor: pointer;
      border: none;
      font-weight: 500;
      padding: 1em 3em;
      outline: none;
      letter-spacing: 1.25px;
      float: right;

      if (loading) {
        background-color: grey;
      }

      if (!isValidUrl(value)) {
        background-color: grey;
      }
    }
  }

  style input {
    outline: none;
    width: 100%;
    height: 5em;
    margin: 0px;

    background-color: #{Color:GREY};
    padding: .5em;

    border: none;
  }

  style buttonContainer {
    /* margin: 10px; */
    position: absolute;
    top: .5em;
    right: 0px;
    z-index: 2;
    height: 100%;
  }

  style button {
    color: #{Color:WHITE};
    background-color: #{Color:BLACK};
    border: none;
    cursor: pointer;
    border: none;
    padding: 1em 3em;
  }

  fun isValidUrl (url : String) : Bool {
    `
    (()=>{
      const urlRegex = /(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/g
    return #{url}.match(urlRegex) !== null
    })()
    `
  }

  fun handleSubmit (event : Html.Event) {
    if (isValidUrl(value)) {
      sequence {
        Html.Event.preventDefault(event)
        onSubmit(value)
        Promise.never()
      }
    } else {
      sequence {
        Html.Event.preventDefault(event)
        Promise.never()
      }
    }

    /* Html.Event.preventDefault(event) */
  }

  fun handleKeyDown (event : Html.Event) {
    case (event.keyCode) {
      13 =>
        sequence {
          onSubmit(value)
          Promise.never()
        }

      => Promise.never()
    }
  }

  fun handleInput (event : Html.Event) {
    onChange(Dom.getValue(event.target))
  }

  fun render : Html {
    <div::container>
      <input
        onKeyDown={handleKeyDown}
        value={value}
        type="text"
        onChange={handleInput}/>

      <a
        href="/site/#{value}"
        onClick={handleSubmit}>

        <button disabled={loading}>
          <{
            if (loading) {
              "LOADING"
            } else {
              "ANALYZE"
            }
          }>
        </button>

      </a>
    </div>
  }
}

module JsRegex {
  fun match (string : String) : Bool {
    `
    (()=>{
      const urlRegex = "^(https?://)?(((www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z‌​0-9]{0,61}[a-z0-9]\\‌​.[a-z]{2,6})|((\\d{1‌​,3}\\.){3}\\d{1,3}))‌​(:\\d{2,4})?((/|\\?)‌​(((%[0-9a-f]{2})|[-\‌​\w@\\+\\.~#\\?&/=])*‌​))?$"
    return string.match(urlRegex) !== null
    })()
    `
  }
}
