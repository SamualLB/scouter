class Scouter::View::Error < Scouter::View
  @path : String
  @error : Exception?

  def initialize(@path, @error)
  end

  def paint(painter : TUI::Painter)
    painter[0, 0] = "Error view: #{@path}"
    painter[0, 2] = @error.to_s if @error
    true
  end

  def parent
    View::Empty.singleton
  end

  def focus
    View::Empty.singleton
  end
end
