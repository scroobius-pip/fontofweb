component ResultPage {
  property initialUrl : String

  state url = ""
  state loading = false
  state result : ReportResult = ReportResult::Empty

  style container {
    background-color: #{Color:PRIMARY};
    padding-bottom: 20%;
    height: 100%;
    width: 100%;
  }

  style sectionheading {
    font-size: 1.5em;
    padding: .5em 1em;
    padding-left: 0;
    font-weight: 500;
    color: #{Color:WHITE};
  }

  style top {
    background-color: #{Color:WHITE};
    height: 100%;
  }

  style inputcontainer {
    margin: auto;
    max-width: 800px;
    text-align: center;
  }

  style mt (value : Number) {
    margin-top: #{value}px;
  }

  style body {
    width: 100%;
    align-items: center;
    z-index: 10;
    position: relative;
    height: 100%;

    h1 {
      font-size: 1.4em;
      text-align: center;
    }
  }

  style results {
    background-color: #{Color:PRIMARY};
    margin: auto;
    margin-top: 48px;
    display: grid;
    max-width: 800px;

    /* height: 100vh; */
  }

  style logocontainer {
    display: flex;
  }

  fun requestReport (url : String) : Promise(Never, ReportResult) {
    sequence {
      /* Timer.timeout(400, "") */
      Report.get(url)

      /* ReportResult::Empty */
    }
  }

  fun handleSubmit (value : String) {
    getReport()
  }

  /*
  get fontCount {

   }
  */
  fun getReport {
    sequence {
      next
        {
          loading = true,
          result = ReportResult::Empty
        }

      parallel {
        requestResult =
          requestReport(url)

        Debug.log(result)
        Promise.never()
      } then {
        next { result = requestResult }
      }
    } finally {
      next { loading = false }
    }
  }

  fun componentDidMount {
    if (String.isEmpty(initialUrl)) {
      Promise.never()
    } else {
      sequence {
        next { url = initialUrl }
        getReport()
      }
    }
  }

  fun getFontList (fontInfo : Map(String, Map(String, FontData))) : Map(String, FontData) {
    fontData
  } where {
    fontInfoValues =
      Map.values(fontInfo)

    fontData =
      fontInfoValues
      |> Array.map(
        (elementData : Map(String, FontData)) {
          elementData
          |> Map.values
          |> Array.reduce(
            Map.empty(),
            (previousMap : Map(String, FontData), item : FontData) {
              Map.empty()
              |> Map.set(item.fontName, item)
              |> Map.merge(previousMap)
            })
        })
      |> Array.reduce(
        Map.empty(),
        (
          previousMap : Map(String, FontData),
          item : Map(String, FontData)
        ) {
          item
          |> Map.merge(previousMap)
        })
  }

  fun renderFontCard (
    elementName : String,
    elementData : Map(String, FontData)
  ) : Html {
    <FontDetailCard
      elementName={elementName}
      elementData={elementData}/>
  }

  fun renderSummaryCard (fontData : FontData) : Html {
    <FontSummaryCard fontData={fontData}/>
  }

  get renderResult {
    case (result) {
      ReportResult::Error err => Html.empty()

      ReportResult::Success data =>
        <div>
          <section>
            <h2::sectionheading>"Summary"</h2>

            <div>
              <{
                getFontList(data.fontInfo)
                |> Map.values
                |> Array.map(renderSummaryCard)
              }>
            </div>
          </section>

          /* <h2>"Details"</h2> */
          <section::mt(40)>
            <h2::sectionheading>"Details"</h2>

            <{
              data.fontInfo
              |> Map.map(renderFontCard)
              |> Map.values()
            }>
          </section>
        </div>

      ReportResult::Empty => Html.empty()
    }
  }

  fun render {
    <div::container>
      <div::top>
        <FontBackground disable={true}>
          <div::body>
            <div::logocontainer>
              <Logo/>
            </div>

            /* <Margin value="60px"/> */
            <div::inputcontainer::mt(48)>
              <AnalyzeInput
                value={url}
                onChange={
                  (value : String) {
                    sequence {
                      if (result != ReportResult::Empty) {
                        next
                          {
                            result = ReportResult::Empty,
                            url = value
                          }
                      } else {
                        next { url = value }
                      }
                    }
                  }
                }
                loading={loading}
                onSubmit={handleSubmit}/>
            </div>

            <h1::mt(24)>
              <{
                case (result) {
                  ReportResult::Empty => "Type a Website and Find Its Fonts"
                  ReportResult::Success data => "#{data.count} font(s) found on #{url}"
                  => "There was an issue getting font data from #{url}"
                }
              }>
            </h1>
          </div>
        </FontBackground>
      </div>

      <Loader display={loading}/>

      <div::results>
        <{ renderResult }>
      </div>

      <div/>

      <{
        case (result) {
          ReportResult::Success data =>
            <>
              <Margin value="20px"/>
              <Footer/>
            </>

          => Html.empty()
        }
      }>
    </div>
  }
}

enum State {
  Loading
  Typing
  Loaded(ReportResult)
  Error
}
