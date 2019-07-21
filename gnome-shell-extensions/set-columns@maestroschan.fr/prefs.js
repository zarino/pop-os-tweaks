
const GObject = imports.gi.GObject;
const Gtk = imports.gi.Gtk;
const Lang = imports.lang;

const Gettext = imports.gettext.domain('set-columns');
const _ = Gettext.gettext;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();
const Convenience = Me.imports.convenience;

//-----------------------------------------------

function init() {
    Convenience.initTranslations();
}

//-----------------------------------------------

const setColumnsSettingsWidget = new GObject.Class({
    Name: 'setColumns.Prefs.Widget',
    GTypeName: 'setColumnsPrefsWidget',
    Extends: Gtk.Box,

    _init: function(params) {
		this.parent(params);
        this.margin = 30;
        this.spacing = 25;
        this.fill = true;
        this.set_orientation(Gtk.Orientation.VERTICAL);
        
		let labelMain = '<b>' + _("Modifications will be effective after reloading the extension.") + '</b>';
		this.add(new Gtk.Label({ label: labelMain, use_markup: true, halign: Gtk.Align.START }));
		
		this._settings = Convenience.getSettings('org.gnome.shell.extensions.set-columns');
		
		let label = _("Maximum number of columns :");
		
		let nbColumns = new Gtk.SpinButton();
        nbColumns.set_sensitive(true);
        nbColumns.set_range(4, 10);
		nbColumns.set_value(6);
        nbColumns.set_value(this._settings.get_int('columns-max'));
        nbColumns.set_increments(1, 2);
        
		nbColumns.connect('value-changed', Lang.bind(this, function(w){
			var value = w.get_value_as_int();
			this._settings.set_int('columns-max', value);
		}));
		
		let hBox = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 15 });
		hBox.pack_start(new Gtk.Label({ label: label, use_markup: true, halign: Gtk.Align.START }), false, false, 0);
		hBox.pack_end(nbColumns, false, false, 0);
		this.add(hBox);
		
	}
});

//-----------------------------------------------

//I guess this is like the "enable" in extension.js : something called each
//time he user try to access the settings' window
function buildPrefsWidget() {
    let widget = new setColumnsSettingsWidget();
    widget.show_all();

    return widget;
}
