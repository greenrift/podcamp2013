local words = {
"ACE","ACED","ACES","ACHE","ACID","ACME","ACNE","ADO","ADS","AID","AIDE","AIDS","AIL","AIM","AIMS","ALE","ALMS","ALOE","ALSO","AMEN","AMID","AND","APE","APED","APES","APSE","ASCI","ASH","ASP","AVID","CALM","CAM","CAME","CAMP","CAN","CANE","CANS","CAP","CAPE","CAPS","CASE","CASH","CAVE","CHAP","CHEM","CHIN","CHIP","CHOP","CLAD","CLAN","CLAP","CLIP","CLOD","COAL","COD","CODE","COED","COIL","COIN","COLD","COME","CON","CONE","COP","COPE","COPS","COVE","DALE","DAM","DAME","DAMN","DAMP","DAMS","DASH","DEAL","DEAN","DEMO","DEN","DENS","DIAL","DICE","DIE","DIEM","DIES","DIM","DIME","DIMS","DIN","DINE","DIP","DIPS","DISC","DISH","DIVE","DOE","DOES","DOLE","DOME","DON","DONE","DONS","DOPE","DOSE","DOVE","EACH","ECHO","ELM","ELMS","ELS","END","ENDS","EON","EONS","EPIC","EVIL","HAD","HAIL","HALE","HAM","HAMS","HAND","HAP","HAS","HAVE","HEAD","HEAL","HEAP","HELD","HELM","HELP","HEM","HEMS","HEN","HENS","HID","HIDE","HIM","HIND","HIP","HIPS","HIS","HIVE","HOE","HOES","HOLD","HOLE","HOME","HONE","HOP","HOPE","HOPS","HOSE","HOVE","ICE","ICED","ICES","ICON","IDE","IDEA","IDEM","IDLE","IDOL","IMP","IMPS","INCH","ION","IONS","ISLE","LACE","LAD","LADS","LAID","LAIN","LAME","LAMP","LAND","LANE","LAP","LAPS","LASH","LEAD","LEAN","LEAP","LED","LEND","LENS","LICE","LID","LIDS","LIE","LIED","LIEN","LIES","LIME","LIMN","LIMP","LINE","LION","LIP","LIPS","LISP","LIVE","LOAD","LOAN","LOCI","LODE","LOIN","LONE","LOP","LOSE","LOVE","MACE","MACH","MAD","MADE","MAID","MAIL","MAIN","MALE","MAN","MANE","MANS","MAP","MAPS","MASH","MEAD","MEAL","MEAN","MEN","MEND","MENS","MESH","MICA","MICE","MID","MIEN","MILD","MILE","MIND","MINE","MOAN","MODE","MOH","MOHS","MOL","MOLD","MOLE","MOP","MOPE","MOPS","MOVE","NAIL","NAME","NAP","NAPS","NEAP","NICE","NIL","NIP","NIPS","NOD","NODE","NODS","NOSE","ODE","ODES","OHM","OHMS","OIL","OILS","OLD","OMEN","OMNI","ONCE","ONE","ONES","OPAL","OPEN","OVA","OVAL","OVEN","PACE","PAD","PADS","PAID","PAIL","PAIN","PAL","PALE","PALM","PALS","PAN","PANE","PANS","PAVE","PEA","PEAL","PEAS","PEN","PEND","PENS","PESO","PHI","PICA","PIE","PIED","PIES","PILE","PIN","PINE","PINS","PION","PLAN","PLEA","PLOD","POD","PODS","POEM","POLE","POND","PONS","POSE","POSH","PSI","SAC","SAD","SAID","SAIL","SALE","SAME","SAND","SANE","SAP","SAVE","SCAM","SCAN","SEA","SEAL","SEAM","SEMI","SEND","SHAM","SHE","SHED","SHIN","SHIP","SHOD","SHOE","SHOP","SIDE","SILO","SIN","SINE","SIP","SLAM","SLAP","SLED","SLID","SLIM","SLIP","SLOP","SNAP","SNIP","SOAP","SOD","SODA","SOIL","SOLD","SOLE","SOME","SON","SOP","SPA","SPAN","SPED","SPIN","VAIN","VALE","VAMP","VAN","VANE","VANS","VASE","VEAL","VEIL","VEIN","VIA","VIAL","VICE","VIE","VIED","VIES","VILE","VINE","VISA","VOID"
}

local letters = {
	"P",	"O",	"D",	"C",	"A",	"M",	"N",	"S",	"H",	"V",	"I",	"L",	"E"
}

local physics = require("physics")
local widget = require("widget")
physics.start()

local centerX = display.contentWidth * 0.5
local centerY = display.contentHeight * 0.5

local createdWord = display.newText("", 0, 0, system.nativeFont, 40)
createdWord.x = centerX
createdWord.y = 30

local status = display.newText("Correct!", 0, 0, system.nativeFont, 50)
status.x = centerX
status.y = centerY
status:setTextColor(0, 255, 0)
status.isVisible = false

local score = display.newText("0", 0, 0, system.nativeFont, 50)
score.x = 25
score.y = 30

local used = {}

local floor = display.newRect( 0, display.contentHeight - 60, display.contentWidth, 10 )
physics.addBody(floor, "static")

local left = display.newRect( 0, 0, 10, display.contentHeight - 60 )
physics.addBody(left, "static")

local right = display.newRect( display.contentWidth - 10, 0, 10, display.contentHeight - 60 )
physics.addBody(right, "static")

function letterTouch(event)
	if(event.phase == "ended") then
		createdWord.text = createdWord.text .. event.target.text
		used[#used + 1] = event.target
	end
	return true
end

function getRandomLetter()
	local text = display.newText(letters[math.random(#letters)], 0, 0, system.nativeFont, 40)
	text.x = math.random(display.contentWidth - 50)
	text.y = 0
	text:setTextColor(math.random(255), math.random(255), math.random(255))
	text:addEventListener("touch", letterTouch)

	physics.addBody(text, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2})
end

function hideStatus()
	status.isVisible = false
end

function submitPressed(event)
	if(event.phase == "ended") then
		for i = 1, #words do
			if(words[i] == createdWord.text) then
				--remove letters
				status.isVisible = true
				timer.performWithDelay(1000, hideStatus, 1)
				score.text = score.text + 1
				while(#used > 0) do
					local temp = table.remove(used)
					display.remove(temp)
					temp = nil
				end
			end
		end
		createdWord.text = ""
		used = nil
		used = {}
	end
	return true
end

local submit = widget.newButton{
	width = 110,
	height = 40,
	label = "Submit",
	onRelease = submitPressed,
}

submit.x = centerX
submit.y = floor.y + 30

timer.performWithDelay(1000, getRandomLetter, 0)


