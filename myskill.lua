--make_legendary.lua
--This script will modify skills, or a single skill
--by vjek, version 1.2, 20120602
--usage is:  target a unit in DF, and execute this script in dfhack
--via ' lua /path/to/script skillname '
--the skill will be increased to 20 (Legendary +5)
--arguments 'list', 'classes' and 'all' added
--praise Armok!

--以上是原作者Reference
--此脚本基于v40.23   
--This Script base on v40.23
--by Ben, version 1.0, 2015.01.15

-- 设置全部技能数和职业数
Total_Skills_Number = 117
Total_Classes_Number = 9

-- 设置特定技能到特定级
function make_legendary(skillname,skillrate)
local skillnamenoun,skillnum
unit=dfhack.gui.getSelectedUnit()

if unit==nil then
	print ("No unit under cursor!  Aborting with extreme prejudice.")
	return
	end

if (df.job_skill[skillname]) then
	skillnamenoun = df.job_skill.attrs[df.job_skill[skillname]].caption_noun
else
	print ("The skill name provided is not in the list.")
	return
	end

if skillnamenoun ~= nil then
	utils = require 'utils'
	skillnum = df.job_skill[skillname]
	utils.insert_or_update(unit.status.current_soul.skills, { new = true, id = skillnum, rating = skillrate}, 'id')
	print (unit.name.first_name.."'s "..skillnamenoun .." skill is setted to " ..skillrate .." now.")
else
	print ("Empty skill name noun, bailing out!")
	return
	end
end

-- 打印全部技能
function PrintSkillList()
local i
for i=0, Total_Skills_Number do
	print("'"..df.job_skill.attrs[i].caption.."' "..df.job_skill[i].." Type: "..df.job_skill_class[df.job_skill.attrs[i].type])

	end
print ("Provide the UPPER CASE argument, for example: PROCESSPLANTS rather than Threshing")
end

-- Output Skills List
-- 输出全部技能名称
function OutputSkillList()
file_name = "C:/game/df_40_23_win/hack/scripts/SkillList.txt"
local f = assert(io.open(file_name, 'w'))
local i
for i=0, Total_Skills_Number do
	f:write("'"..df.job_skill.attrs[i].caption.."' "..df.job_skill[i].." Type: "..df.job_skill_class[df.job_skill.attrs[i].type] .."\n")
	end
f:close()
end

-- 设置全部技能到20级
function BreathOfArmok()
unit=dfhack.gui.getSelectedUnit()
if unit==nil then
	print ("No unit under cursor!  Aborting with extreme prejudice.")
	return
	end
local i
utils = require 'utils'
for i=0, Total_Skills_Number do
	utils.insert_or_update(unit.status.current_soul.skills, { new = true, id = i, rating = 20 }, 'id')
	end
print ("The breath of Armok has engulfed "..unit.name.first_name)
end

-- 设置全部技能到特定的等级
function SetAllTo(Skill_Rate)
unit=dfhack.gui.getSelectedUnit()
if unit==nil then
	print ("No unit under cursor!  Aborting with extreme prejudice.")
	return
	end
local i
utils = require 'utils'
for i=0, Total_Skills_Number do
	utils.insert_or_update(unit.status.current_soul.skills, { new = true, id = i, rating = Skill_Rate }, 'id')
	end
print (unit.name.first_name .."'s All Skills are setted to " ..Skill_Rate )
end

-- 把特定职业的技能升到20级
function LegendaryByClass(skilltype)
unit=dfhack.gui.getSelectedUnit()
if unit==nil then
	print ("No unit under cursor!  Aborting with extreme prejudice.")
	return
	end

utils = require 'utils'
local i
local skillclass
for i=0, Total_Skills_Number do
	skillclass = df.job_skill_class[df.job_skill.attrs[i].type]
	if skilltype == skillclass then
		print ("Skill "..df.job_skill.attrs[i].caption.." is type: "..skillclass.." and is now Legendary for "..unit.name.first_name)
		utils.insert_or_update(unit.status.current_soul.skills, { new = true, id = i, rating = 20 }, 'id')
		end
	end
end

-- 输出相关职业的所有技能
function PrintSkillClassList()
local i
for i=0, Total_Classes_Number do
	print(df.job_skill_class[i])
	end
print ("Provide one of these arguments, and all skills of that type will be made Legendary")
print ("For example: Medical will make all medical skills legendary")
end

--main script operation starts here
----
local opt = {...}
local skillname
local skillrate

if opt then
	if opt[1]=="list" then
		PrintSkillList()
		return
		end
	if opt[1]=="classes" then
		PrintSkillClassList()
		return
		end
	if opt[1]=="all" then
		BreathOfArmok()
		return
		end
	if opt[1]=="Output_List" then
		OutputSkillList()
		return
		end
	if opt[1]=="Normal" or opt[1]=="Medical" or opt[1]=="Personal" or opt[1]=="Social" or opt[1]=="Cultural" or opt[1]=="MilitaryWeapon" or opt[1]=="MilitaryUnarmed" or opt[1]=="MilitaryAttack" or opt[1]=="MilitaryDefense" or opt[1]=="MilitaryMisc" then
		LegendaryByClass(opt[1])
		return
		end
	-- 提升所有军事技能相关到20级
	if opt[1] == "Spartan" then
		LegendaryByClass("MilitaryWeapon")
		LegendaryByClass("MilitaryUnarmed")
		LegendaryByClass("MilitaryAttack")
		LegendaryByClass("MilitaryDefense")
		LegendaryByClass("MilitaryMisc")
		return
		end
	if opt[1]=="SetAllTo" then
		SetAllTo(opt[2])
		return
		end
	skillname = opt[1]
	if opt[2] then
		skillrate = opt[2]
	else
		skillrate = 20
	end
else
	print ("No skillname supplied.  Pass argument 'list' to see a list, 'classes' to show skill classes, or use 'all' if you want it all!")
	return
	end

make_legendary(skillname,skillrate)
