class Scouter::View::Empty < Scouter::View
  @@singleton : self?

  private def initialize
    @@singleton = self
  end

  def self.singleton : self
    @@singleton || self.new
  end

  def paint(painter : TUI::Painter)
    painter[0, 0] = "Empty View"
    true
  end

  def parent : View
    self
  end

  def focus : View
    self
  end
end
