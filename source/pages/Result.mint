component ResultPage {
  style container {
    background-color: #{Color:PRIMARY};

    height: 100%;
  }

  style top {
    background-color: #{Color:WHITE};
  }

  style bottom {

  }

  style body {
    background: transparent;

    margin-top: 10em;
    position: relative;
    z-index: 10;
    text-align: center;

    h1 {
      font-size: 2em;
      margin: auto;
      text-align: center;
    }
  }

  style results {
    background-color: #{Color:PRIMARY};
    margin: auto;
    margin-top: 40px;
    max-width: 542px;
  }

  fun render {
    <div::container>
      <div::top>
        <FontBackground>
          <nav>
            <Logo/>
          </nav>

          <div::body>
            <Margin value="15px"/>
            <AnalyzeInput/>
            <Margin value="36px"/>
            <h1>"3 fonts were found on www.facebook.com"</h1>
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
