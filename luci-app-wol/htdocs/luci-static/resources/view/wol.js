'use strict';
'require view';
'require form';
'require fs';

return view.extend({
	render: function(data) {
		var m, s, mac;

		m = new form.Map('etherwake', _('Wakeup On LAN'), _('Wakeup On LAN is a mechanism to remotely boot computers in the local network.'));
		s = m.section(form.GridSection, 'target');
		s.nodescriptions = true;
		s.anonymous = true;
		s.addremove = true;

		s.option(form.Value, 'name', _('Name'), _('the Name of device'));

		mac = s.option(form.Value, 'mac', _('MAC'), _('the MAC of device'));

		var btn = s.option(form.Button, '_apply', _('Wakeup'));
		btn.editable = true;
		btn.modalonly = false;
		btn.inputstyle = 'apply';
		btn.onclick = function(ev, section_id) {
			var val = mac.cfgvalue(section_id);
			fs.exec('/usr/bin/etherwake', ['-D', '-i', 'br-lan', val])
				.then(function(res) {
					alert(res.stdout + res.stderr);
				})
				.catch(function(err) {
					alert(err);
				});
		};
		return m.render();
	},
});