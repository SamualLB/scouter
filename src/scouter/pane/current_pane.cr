class Scouter::CurrentPane < Scouter::Pane
  def next : Bool
    return false unless view.next
    browser.right.view = view.focus
    true
  end

  def previous : Bool
    return false unless view.previous
    browser.right.view = view.focus
    true
  end
end
