class Scouter::Application < TUI::Widget::Main
  property! browser : Browser
  
  def initialize
    super(nil)
    layout << (@browser = Browser.new(self))
  end

  def key(event : TUI::Event::Key)
    
  end
end
