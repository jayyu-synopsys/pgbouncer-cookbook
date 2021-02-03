name             "pgbouncer"
provides         "pgbouncer"
maintainer       "Jay Yu"
maintainer_email "jayyu@synopsys.com"
description      "Installs/Configures pgbouncer"
version          "1.0.3"

%w{ubuntu}.each do |os|
  supports os
end
depends "apt"

