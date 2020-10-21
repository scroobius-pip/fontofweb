component ResultPage {
  property url : String

  style container {
    background-color: #{Color:PRIMARY};
    padding-bottom: 20%;
    height: 100%;
  }

  style top {
    background-color: #{Color:WHITE};
  }

  style inputcontainer {
    margin: auto;
    max-width: 600px;
    text-align: center;
  }

  style body {
    width: 100%;

    /* display: flex; */

    /* justify-content: space-between; */
    align-items: center;

    /* background: orange; */
    z-index: 10;
    position: relative;

    h1 {
      font-size: 1.8em;

      /* margin: auto; */
      text-align: center;
    }
  }

  style results {
    background-color: #{Color:PRIMARY};
    margin: auto;
    margin-top: 48px;
    max-width: 542px;
  }

  style logocontainer {
    display: flex;

    /* align-items: flex-start; */
  }

  fun render {
    <div::container>
      <div::top>
        <FontBackground>
          <div::body>
            <div::logocontainer>
              <Logo/>
            </div>

            <Margin value="60px"/>

            <div::inputcontainer>
              <AnalyzeInput/>
              <Margin/>
            </div>

            <h1>"3 fonts were found on #{url}"</h1>
          </div>
        </FontBackground>
      </div>

      <div::results>
        <FontCard/>
        <FontCard/>
        <FontCard/>
        <FontCard/>
        <FontCard/>
      </div>

      <div/>
    </div>
  }
}
