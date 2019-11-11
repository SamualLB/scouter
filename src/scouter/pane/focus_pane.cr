class Scouter::FocusPane < Scouter::Pane
  def next : Bool
    view.next
  end

  def previous : Bool
    view.previous
  end
end
