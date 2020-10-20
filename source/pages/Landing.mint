component LandingPage {
  style logo {
    width: 100%;
    height: 1.8em;
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
    background-color: transparent;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
  }

  fun render {
    <div::container>
      <FontBackground>
        <nav>
          <Logo/>
        </nav>

        <div::body>
          <h1>"Type a Website and Find Its Fonts"</h1>

          <Margin value="15px"/>

          <AnalyzeInput/>
        </div>
      </FontBackground>
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
