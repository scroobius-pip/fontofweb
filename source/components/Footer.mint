component Footer {
  style link {
    color: white;
    opacity: 0.8;

    font-weight: 600;

    &:hover {
      opacity: 1;
    }
  }

  fun render {
    <div style="text-align:center">
      <div>
        <a::link href="https://twitter.com/font_web">
          "Follow Us On Twitter"
        </a>

        <br/>

        <a::link href="https://discord.gg/hpNGYZ58Aa">
          "Have any issues ? Report on the Discord Group"
        </a>
      </div>

      <Margin/>

      <p style="color:white;opacity:0.5;">
        "This tool is for educational use and downloaded fonts may require additional licensing for personal or commercial use."
      </p>

      <Margin/>

      <a::link
        style="margin-top:20px;padding-bottom:50px;"
        href="https://www.notion.so/Font-of-Web-875c921acd8d419488899ddb29f5850a">

        "Legal"

      </a>
    </div>
  }
}
