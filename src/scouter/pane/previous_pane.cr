class Scouter::PreviousPane < Scouter::Pane
  def next : Bool
    return false unless view.next
    browser.mid.view = view.focus
    browser.right.view = browser.mid.view.focus
    true
  end

  def previous : Bool
    return false unless view.previous
    browser.mid.view = view.focus
    browser.right.view = browser.mid.view.focus
    true
  end
end
