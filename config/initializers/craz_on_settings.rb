CRAZ_ON_SETTINGS = HashWithIndifferentAccess.new(Rails.application.config_for(:craz_on_settings))

def build_url()
  custom_port =
    ![443, 80].include?(CRAZ_ON_SETTINGS[:port].to_i) ?
    ":#{CRAZ_ON_SETTINGS[:port]}" : nil

  [ CRAZ_ON_SETTINGS[:protocol],
    "://",
    CRAZ_ON_SETTINGS[:host],
    custom_port,
    CRAZ_ON_SETTINGS[:relative_url_root],
  ].join('')
end

CRAZ_ON_SETTINGS[:url] = build_url()

CRAZ_ON_SETTINGS[:points] = {
  likes_100: 10,
  comments_100: 100,
  shares_100: 1000,
  blogs_100: 10000
}

CRAZ_ON_SETTINGS[:titles] = {
  likes_100: 'Best Liker',
  comments_100: 'Best Commentor',
  blogs_100: 'Best Poster',
  shares_100: 'Best Sharer',
  all_1000: 'Best Social Person',
  abused_blocked_100: 'Worst Social Person',
  blocks_100: 'The Wall'
}

CRAZ_ON_SETTINGS[:locations] = ['Chennai', 'Bangalore', 'Mumbai', 'Kolkata', 'Delhi']

CRAZ_ON_SETTINGS[:session_expiry_time] = 172_800

CRAZ_ON_SETTINGS[:mailer_default_from] = 'notifications@rails_e2_soln.com'
