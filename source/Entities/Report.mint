record FontVariant {
  weight : String,
  lineHeight : String,
  size : String
}

record FontData {
  fallbacks : Array(String),
  fontName : String,
  src : Map(String, String),
  variants : Array(FontVariant)
}

record Report {
  fontInfo : Map(String, Map(String, FontData)),
  count : Number
}

enum ReportResult {
  Error(String)
  Success(Report)
  Empty
}

/* Map(String,Map(String,FontData)) */
module Report {
  fun parseResponse (string : String) : ReportResult {
    try { 
      object =
        Json.parse(string)
        |> Maybe.toResult(ReportResult::Error("Unable to Parse"))

      decoded =
        decode object as Report

      ReportResult::Success(decoded)
    } catch ReportResult => result {
      case (result) {
        ReportResult::Success value => ReportResult::Success(value)
        ReportResult::Error error => ReportResult::Error(error)
        ReportResult::Empty => ReportResult::Empty
      }
    } catch Object.Error => error {
      ReportResult::Error("Unable to Parse")
    }
  }

  fun get (url : String) : Promise(Never, ReportResult) {
    sequence {
      normalizedUrl =
        normalizeUrl(url)

      response =
        "https://api.fontofweb.com/?url=#{String.trim(url)}"
        |> Http.get()
        |> Http.send()

      parseResponse(response.body)
    } catch Http.ErrorResponse => error {
      ReportResult::Error("Unable to Request")
    }
  }

  fun normalizeUrl (urlString : String) : String {
    try {
      url =
        urlString
        |> Url.parse()

      if (url.path == "/") {
        url.hostname
      } else {
        "#{url.hostname}#{url.path}"
      }
    }
  }

  fun getMock (url : String) : Promise(Never, ReportResult) {
    sequence {
      body =
        "{\"fontInfo\":{\"span\":{\"Helvetica\":{\"fallbacks\":[\"Arial\",\"sans-serif\"],\"fontName\":\"Helvetica\",\"src\":{},\"variants\":[{\"lineHeight\":\"24px\",\"size\":\"12px\",\"weight\":\"700\"},{\"lineHeight\":\"22px\",\"size\":\"12px\",\"weight\":\"700\"},{\"lineHeight\":\"24px\",\"size\":\"12px\",\"weight\":\"400\"},{\"lineHeight\":\"14.74px\",\"size\":\"11px\",\"weight\":\"400\"},{\"lineHeight\":\"16.08px\",\"size\":\"12px\",\"weight\":\"400\"}]}},\"h2\":{\"SFProDisplay-Regular\":{\"fallbacks\":[\"Helvetica\",\"Arial\",\"sans-serif\"],\"fontName\":\"SFProDisplay-Regular\",\"src\":{},\"variants\":[{\"lineHeight\":\"32px\",\"size\":\"28px\",\"weight\":\"400\"}]}},\"a\":{\"Helvetica\":{\"fallbacks\":[\"Arial\",\"sans-serif\"],\"fontName\":\"Helvetica\",\"src\":{},\"variants\":[{\"lineHeight\":\"22px\",\"size\":\"12px\",\"weight\":\"700\"},{\"lineHeight\":\"18.76px\",\"size\":\"14px\",\"weight\":\"500\"},{\"lineHeight\":\"48px\",\"size\":\"17px\",\"weight\":\"700\"},{\"lineHeight\":\"16.08px\",\"size\":\"12px\",\"weight\":\"400\"},{\"lineHeight\":\"18px\",\"size\":\"12px\",\"weight\":\"700\"},{\"lineHeight\":\"19.2px\",\"size\":\"12px\",\"weight\":\"400\"}]},\"SFProText-Semibold\":{\"fallbacks\":[\"Helvetica\",\"Arial\",\"sans-serif\"],\"fontName\":\"SFProText-Semibold\",\"src\":{},\"variants\":[{\"lineHeight\":\"18.76px\",\"size\":\"14px\",\"weight\":\"600\"}]}},\"button\":{\"Helvetica\":{\"fallbacks\":[\"Arial\",\"sans-serif\"],\"fontName\":\"Helvetica\",\"src\":{},\"variants\":[{\"lineHeight\":\"48px\",\"size\":\"20px\",\"weight\":\"700\"}]}}},\"error\":\"\",\"count\":2}"

      parseResponse(body)
    }
  }
}
