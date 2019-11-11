class Scouter::View::Unknown < Scouter::View
  @path : String

  def initialize(@path)
    View.cache[@path] = self
  end

  def paint(painter : TUI::Painter)
    painter[0, 0] = ::File.basename(@path)
    begin
      painter[0, 2] = "Unrecognised filesystem type"
      painter[0, 3] = "#{::File.info?(@path).try &.type}"
    rescue ex : Errno
      painter[0, 2] = ex.to_s
    end
    true
  end

  def parent
    View::Empty.singleton
  end

  def focus
    View::Empty.singleton
  end
end
