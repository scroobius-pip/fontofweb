component AnalyzeInput {
  style container {
    background-color: #{Color:GREY};
    width: 100%;
    border: none;
    padding: 1em;
    display: flex;
    justify-content: space-between;
    max-width: 540px;
    margin: auto;

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
      border: none;
      cursor: pointer;
      border: none;
      font-weight: 500;
      padding: 1em 3em;

      letter-spacing: 1.25px;
      float: right;
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

  fun render : Html {
    <div::container>
      <input type="text"/>
      <button>"ANALYZE"</button>
    </div>
  }
}
