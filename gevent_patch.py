# gevent_patch.py
# Este archivo debe ser importado antes que cualquier otro módulo que use SSL
from gevent import monkey
monkey.patch_all()

print("Gevent monkey patching applied successfully")
