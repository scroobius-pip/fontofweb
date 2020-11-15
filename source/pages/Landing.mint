component LandingPage {
  state url = ""

  style logo {
    width: 100%;
    height: 1.8em;
  }

  style inputcontainer {
    margin: auto;
    max-width: 600px;
    text-align: center;
  }

  style logocontainer {
    display: flex;

    /* align-items: flex-start; */
  }

  style body {
    height: 100%;

    width: 100%;
    background: transparent;

    margin-top: 10em;
    position: relative;
    z-index: 10;

    h1 {
      font-size: 2em;
      margin: auto;
      text-align: center;
    }
  }

  style container {
    height: 100vh;
    background-color: "#{Color:WHITE}";

    /* display: flex; */
    align-items: center;
    justify-content: center;
    flex-direction: column;
  }

  fun handleSubmit (value : String) {
    Navigation.goTo(Page::Result(value))
  }

  fun render {
    <div::container>
      <FontBackground>
        <div::logocontainer>
          <Logo/>
        </div>

        <div::body>
          <h1>"Type a Website and Find Its Fonts"</h1>

          <Margin value="15px"/>

          <div::inputcontainer>
            <AnalyzeInput
              value={url}
              onChange={(value : String) { next { url = value } }}
              loading={false}
              onSubmit={handleSubmit}/>

            <Margin/>
          </div>
        </div>
      </FontBackground>

      <Footer/>
    </div>
  }
}

component Margin {
  property value = "10px"

  style margin {
    margin-top: #{value};
  }

  fun render {
    <div::margin/>
  }
}
