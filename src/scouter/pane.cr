abstract class Scouter::Pane < TUI::Widget
  property! view : View

  def paint(painter : TUI::Painter)
    view.paint(painter)
    true
  end

  def browser : Browser
    self.parent!.as(Browser)
  end

  abstract def next : Bool
  abstract def previous : Bool
end

require "./pane/*"
