extends Resource


var ziegelTyp = null setget set_ziegel_typ
var bereicheSchuere = [] setget set_bereiche_schnuere
var bereicheLatten = [] setget set_bereiche_latten
var schnittlinie = null setget set_schnittlinie

# signal changed(einstellungen)


func set_bereiche_schnuere(bereiche):
	bereicheSchuere = bereiche
	emit_signal("changed", self)


func set_bereiche_latten(bereiche):
	bereicheLatten = bereiche
	emit_signal("changed", self)


func set_ziegel_typ(_ziegelTyp):
	ziegelTyp = _ziegelTyp
	emit_signal("changed", self)


func set_schnittlinie(_schnittlinie):
	schnittlinie = _schnittlinie
	emit_signal("changed", self)
