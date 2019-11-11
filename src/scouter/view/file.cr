class Scouter::View::File < Scouter::View
  @path : String

  def initialize(@path)
    View.cache[@path] = self
  end

  def paint(painter : TUI::Painter)
    painter[0, 0] = ::File.basename(@path)
    begin
      ::File.open(@path) { |d| painter[0, 2] = d.gets_to_end }
    rescue ex : Errno
      painter[0, 2] = ex.to_s
    end
    true
  end

  def parent : View
    View::Empty.singleton
  end

  def focus : View
    View::Empty.singleton
  end
end
