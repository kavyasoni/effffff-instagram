threads 1, 6
workers 2

pidfile "/home/deploy/agameoftags/tmp/puma/pid"
state_path "/home/deploy/agameoftags/tmp/puma/state"
bind 'unix:///home/deploy/agameoftags/tmp/sockets/puma.sock'
environment 'production'
activate_control_app