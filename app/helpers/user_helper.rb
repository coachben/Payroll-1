module UserHelper
  def self.get_all(pagenum, pagesize)
    total = User.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = User.order('username').all(:offset => pager.lower_bound, :limit => pager.pagesize)
    { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => pagenum + 1, :prevpage => pagenum - 1,
      :list => list }
  end
  
  def self.get_filter_by(keyword, pagenum, pagesize)
    criteria = User.where('username like ?', "%#{keyword}%")
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = criteria.order('title').all(:offset => pager.lower_bound, :limit => pager.pagesize)
    { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => pagenum + 1, :prevpage => pagenum - 1,
      :list => list }
  end
  
  def self.get_errors(errors, attr = {})
    m = {}
    errors.each do |k, v|
      if v == 'user.unique.username'
        m[k] = I18n.t(v, :value => attr[:username])
        next

      elsif v == 'user.tooshort.username'
        m[k] = I18n.t(v, :value => 3)
        next
        
      elsif v == 'user.tooshort.password'
        m[k] = I18n.t(v, :value => 4)
        next
        
      end
      m[k] = I18n.t(v)
    end
    { :error => 1, :errors => m }
  end
  
  def self.item_message(keyword, pagenum, pagesize)
    total = 0
    if keyword.blank?
      total = User.count
      pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
      return pager.item_message
      
    else
      criteria = User.where('username like ?', "%#{keyword}%")
      total = criteria.count
      pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
      return pager.item_message
    end
  end
end
