function doGet() {
  const htmlOutput = HtmlService.createTemplateFromFile("src/home").evaluate();
  return htmlOutput.setTitle("Web Template Site");
}
