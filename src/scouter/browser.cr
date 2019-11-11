class Scouter::Browser < TUI::Widget
  getter! left : PreviousPane
  getter! mid : CurrentPane
  getter! right : FocusPane

  def initialize(parent : TUI::Widget)
    super(parent)
    @layout = TUI::Layout::Horizontal.new(self)
    @left = PreviousPane.new(self)
    @mid = CurrentPane.new(self)
    @right = FocusPane.new(self)

    start_dir = ARGV[0]?
    mid.view = if start_dir
      if ::Dir.exists?(start_dir)
        View::Dir.new(start_dir)
      else
        TUI.logger.info "Directory #{start_dir} does not exist"
        View::Dir.new
      end
    else
      View::Dir.new
    end

    left.view = mid.view.parent
    right.view = mid.view.focus

    bind(TUI::Key::Left) { |k| up_dir(); true }
    bind(TUI::Key::Right) { |k| down_dir(); true }
    bind('h') { |k| up_dir(); true }
    bind('l') { |k| down_dir(); true }

    bind(TUI::Key::Up) { |k| mid.previous; true }
    bind(TUI::Key::Down) { |k| mid.next; true }
    bind('k') { |k| mid.previous; true }
    bind('j') { |k| mid.next; true }

    bind('[') { |k| left.previous; true }
    bind(']') { |k| left.next; true }

    mid.bind(TUI::MouseStatus::ScrollUp) { |m| mid.previous; true }
    mid.bind(TUI::MouseStatus::ScrollDown) { |m| mid.next; true }
    left.bind(TUI::MouseStatus::ScrollUp) { |m| left.previous; true }
    left.bind(TUI::MouseStatus::ScrollDown) { |m| left.next; true }
    right.bind(TUI::MouseStatus::ScrollUp) { |m| right.previous; true }
    right.bind(TUI::MouseStatus::ScrollDown) { |m| right.next; true }
  end

  private def up_dir : self
    return self if left.view.is_a?(View::Empty)
    right.view = mid.view
    mid.view = left.view
    left.view = mid.view.parent
    self
  end

  private def down_dir : self
    return self if right.view.is_a?(View::Empty) || right.view.is_a?(View::File)
    left.view = mid.view
    mid.view = right.view
    right.view = mid.view.focus
    self
  end
end
