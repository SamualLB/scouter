class Scouter::View::Dir < Scouter::View
  @path : String
  @entries = [] of String
  @index = 0
  @error : Exception? = nil

  def initialize(p)
    @path = ::File.real_path(p)
    View.cache[@path] = self
    begin
      @entries = ::Dir.children(@path)
    rescue ex : Errno
      TUI.logger.info ex.to_s
      @error = ex
    end
    sort!
  end

  def self.new()
    self.new(::Dir.current)
  end

  def paint(painter : TUI::Painter)
    painter[0, 0] = @path == "/" ? '/' : ::File.basename(@path) + '/'
    if @error
      painter[0, 2] = @error.to_s
      return true
    end
    return true if @entries.empty?
    painter.push(0, 2)

    start_index = @index - painter.h/2
    end_index = @index + (painter.h+0.5)/2
    count = 0
    (start_index...end_index).each do |i|
      count += 1
      next unless i >= 0
      next unless @entries[i]?
      painter.push(0, count-1, new_h: 1)
      selected = @index == i
      if selected
        painter.w.times { |n| painter[n, 0] = '-' }
      end
      painter[0, 0] = @entries[i]
      painter.pop
    end

    painter.pop
    true
  end

  def parent : View
    return View::Empty.singleton if @path == "/"
    par_path = @path.rpartition('/')[0]
    par_path = "/" if par_path.empty?
    par_view = (View.cached(par_path) || View::Dir.new(par_path)).as(View::Dir)
    par_view.set_index(::File.basename(@path))
  end

  def focus : View
    return View::Empty.singleton if @entries.empty?
    View.resolve(@path + '/' + @entries[@index])
  end

  def set_index(ent : String) : self
    @entries.each_with_index do |e, i|
      next unless e == ent
      @index = i
    end
    self
  end

  def next : Bool
    if @index < @entries.size-1
      @index += 1 
      return true
    end
    false
  end

  def previous : Bool
    unless @index <= 0
      @index -= 1
      return true
    end
    false
  end

  private def sort! : self
    @entries.sort! do |a, b|
      a_dir : Bool? = nil
      b_dir : Bool? = nil
      begin
        a_dir = ::File.directory?(@path + '/' + a)
      rescue ex : Errno
        a_dir = nil
      end
      begin
        b_dir = ::File.directory?(@path + '/' + b)
      rescue ex : Errno
        b_dir = nil
      end
      if (a_dir && b_dir) || (!a_dir && !b_dir)
        a.downcase <=> b.downcase
      elsif (a_dir)
        -1
      else (b_dir)
        1
      end
    end
    self
  end
end
