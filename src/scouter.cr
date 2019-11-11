require "tui"
require "./scouter/*"

module Scouter
  VERSION = "0.1.0"
end

sc = Scouter::Application.new()

app = TUI::Application.new(sc, title: "Scouter")
sc.browser.set_focused true

app.exec
