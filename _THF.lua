-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.
-- Initialization function for this job file.
function get_sets()
-- Load and initialize the include file.
mote_include_version = 2
include('Mote-Include.lua')
include('organizer-lib')
end

-- Setup vars that are user-independent.
function job_setup()
	state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
	state.Buff['Trick Attack'] = buffactive['trick attack'] or false
	state.Buff['Feint'] = buffactive['feint'] or false
	state.HasteMode = M{['description']='Haste Mode', 'Normal', 'Hi' }
	include('Mote-TreasureHunter')
	determine_haste_group()

-- For th_action_check():
-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}

-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
-- Options: Override default values
	state.OffenseMode:options('Normal','Acc')
	state.HybridMode:options('Normal', 'Evasion', 'PDT')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Mid', 'Acc')
	state.IdleMode:options('Normal')
	state.RestingMode:options('Normal')
	state.PhysicalDefenseMode:options('Evasion', 'PDT')
	state.MagicalDefenseMode:options('MDT')
	state.RangedMode:options('Normal')

-- Additional local binds
	send_command('bind ^= gs c cycle treasuremode')
	send_command('bind ^J input /ja "Spectral Jig" <me>')
	send_command('bind @f9 gs c cycle HasteMode')
	send_command('bind ^V paste')
	select_default_macro_book()
end
-- Called when this job file is unloaded (eg: job change)
function file_unload()
	send_command('unbind ^=')
	send_command('unbind ^J')
	send_command ('unbind @f9')
end

function init_gear_sets()
-- Start defining the sets

	sets.TreasureHunter = {hands="Plun. Armlets +1",feet="Skulk. Poulaines", waist="Chaac Belt"}

	sets.ExtraRegen = {}

	sets.buff['Sneak Attack'] = 
	{head={ name="Lilitu Headpiece", augments={'STR+9','DEX+6','Attack+13',}},
	body={ name="Rawhide Vest", augments={'HP+50','"Subtle Blow"+7','"Triple Atk."+2',}},
	hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
	legs={ name="Lustratio Subligar", augments={'Attack+15','STR+5','"Dbl.Atk."+2',}},
	feet={ name="Rawhide Boots", augments={'STR+10','Attack+15','"Store TP"+5',}},
	neck="Caro Necklace",
	waist="Chiner's Belt +1",
	left_ear="Bladeborn Earring",
	right_ear="Tati Earring",
	left_ring="Rajas Ring",
	right_ring="Dagaz Ring",
	back="Bleating Mantle"}

	sets.buff['Trick Attack'] = 
	{head="Pill. Bonnet +1",
	body={ name="Rawhide Vest", augments={'HP+50','"Subtle Blow"+7','"Triple Atk."+2',}},
	hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
	legs="Pill. Culottes +1",
	feet={ name="Herculean Boots", augments={'Accuracy+26','"Triple Atk."+2','AGI+8',}},
	neck="Caro Necklace",
	waist="Caudata Belt",
	left_ear="Bladeborn Earring",
	right_ear="Tati Earring",
	left_ring="Stormsoul Ring",
	right_ring="Dagaz Ring",
	back="Bleating Mantle"}

	sets.precast.JA['Collaborator'] = {head="Skulker's Bonnet +1"}
	sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +1"}
	sets.precast.JA['Flee'] = {feet="Pill. Poulaines +1"}
	sets.precast.JA['Hide'] = {body="Pillager's Vest +1"}
	sets.precast.JA['Conspirator'] = {} -- {body="Raider's Vest +2"}
	sets.precast.JA['Steal'] = {head="Plun. Bonnet +1",hands="Pill. Armlets +1",legs="Pill. Culottes +1",feet="Pill. Poulaines +1"}
	sets.precast.JA['Despoil'] = {}
	sets.precast.JA['Mug'] = {head="Plun. Bonnet +1"}
	sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
	sets.precast.JA['Feint'] = {hands="Plun. Culottes +1"}
	sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
	sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

-- For Curing Waltz (CHR+VIT)
	sets.precast.Waltz = 
	{ammo="Imperial Egg",
	head="Lithelimb Cap",
	body="Emet Harness +1",
	hands={ name="Plun. Armlets +1", augments={'Enhances "Perfect Dodge" effect',}},
	legs={ name="Plun. Culottes +1", augments={'Enhances "Feint" effect',}},
	feet={ name="Rawhide Boots", augments={'STR+10','Attack+15','"Store TP"+5',}},
	neck="Twilight Torque",
	waist="Caudata Belt",
	left_ear="Infused Earring",
	right_ear="Reraise Earring",
	left_ring="Airy Ring",
	right_ring={ name="Dark Ring", augments={'Phys. dmg. taken -6%','Magic dmg. taken -5%',}},
	back="Earthcry Mantle"}

-- TH actions
	sets.precast.Step = sets.TreasureHunter
	sets.precast.Flourish1 = sets.TreasureHunter
	sets.precast.JA.Provoke = sets.TreasureHunter

-- Fast cast sets for spells
	sets.precast.FC = {
	ammo="Sapience Orb",
	head="Haruspex Hat",
	hands="Leyline Gloves",
	body={ name="Taeon Tabard", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+2','MND+4 CHR+4',}},
	legs="Limbo Trousers",
	left_ear="Loquac. Earring",
	left_ring="Prolix Ring",
	right_ring="Lebeche Ring"}

-- Utsusemi Spells Precast
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

-- Ranged Snapshot/Midcast gear
	sets.precast.RA = {}
	sets.midcast.RA = {}

-------------------------	
-->>>> Weaponskill sets |
-------------------------

-- Non defined Weaponskill
	sets.precast.WS = {
	head={ name="Lilitu Headpiece", augments={'STR+9','DEX+6','Attack+13',}},
	body={ name="Rawhide Vest", augments={'HP+50','"Subtle Blow"+7','"Triple Atk."+2',}},
	hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
	legs={ name="Lustratio Subligar", augments={'Attack+15','STR+5','"Dbl.Atk."+2',}},
	feet={ name="Rawhide Boots", augments={'STR+10','Attack+15','"Store TP"+5',}},
	neck="Caro Necklace",
	waist="Chiner's Belt +1",
	left_ear="Tati Earring",
	right_ear="Brutal Earring",
	left_ring="Rufescent Ring",
	right_ring="Karieyh Ring",
	back="Bleating Mantle"}
	-- Acc + 20% ws
	sets.precast.WS.Acc = set_combine(sets.precast.WS,{neck="Fotia Gorget",waist="Fotia Belt"})
	--SATA sets + 10% critical hit + 20% acc + 20% WS damage
	sets.precast.WS.SA = set_combine(sets.precast.WS,{
	head="Pill. Bonnet +1",
	body="Pillager's Vest +1",
	hands="Pill. Armlets +1",
	neck="Fotia Gorget",
	waist="Fotia Belt"})
	sets.precast.WS.TA = sets.precast.WS.SA
	sets.precast.WS.SATA = sets.precast.WS.SA

-- Switch Between Night/Day ammo Stat changes:- will apply to all WS unless deined
	sets.NightWS = {ammo="Hasty Pinion +1"}
	sets.DayWS = {ammo="Tengu-no-Hane"}
	
--> Rudra's Storm Set <--
	sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {back="Canny Cape",left_ring="Rajas Ring",feet="Herculean Boots"})
	sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"],{head={ name="Taeon Chapeau", augments={'Accuracy+17 Attack+17','Weapon Skill Acc.+18','Weapon skill damage +2%',}},neck="Fotia Gorget",waist="Fotia Belt"})
	sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"],{
	head="Pill. Bonnet +1",
	body="Pillager's Vest +1",
	hands="Pill. Armlets +1"})
	sets.precast.WS["Rudra's Storm"].TA = sets.precast.WS["Rudra's Storm"].SA
	sets.precast.WS["Rudra's Storm"].SATA = sets.precast.WS["Rudra's Storm"].SA
	
--> Evisceration Set <--
	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS,{left_ring="Rajas Ring"})
	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'],{head={ name="Taeon Chapeau", augments={'Accuracy+17 Attack+17','Weapon Skill Acc.+18','Weapon skill damage +2%',}},neck="Fotia Gorget",waist="Fotia Belt"})
	--SATA sets + 10% critical hit + 20% acc + 20% WS damage
	sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'],{
	head="Pill. Bonnet +1",
	body="Pillager's Vest +1",
	hands="Pill. Armlets +1",
	neck="Fotia Gorget",
	waist="Fotia Belt"})
	sets.precast.WS['Evisceration'].TA = sets.precast.WS['Evisceration'].SA
	sets.precast.WS['Evisceration'].SATA = sets.precast.WS['Evisceration'].SA

--> Aeolian Edge Set <--
	sets.precast.WS['Aeolian Edge'] ={
	ammo="Honed Tathlum",
	head="Highwing Helm",
	body={ name="Samnuha Coat", augments={'Mag. Acc.+12','"Mag.Atk.Bns."+12','"Dual Wield"+3',}},
	hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
	legs="Limbo Trousers",
	feet={ name="Herculean Boots", augments={'Accuracy+26','"Triple Atk."+2','AGI+8',}},
	neck="Stoicheion Medal",
	waist="Fotia Belt",
	left_ear="Friomisi Earring",
	right_ear="Hecate's Earring",
	left_ring="Acumen Ring",
	right_ring="Shiva Ring",
	back="Letalis Mantle"}

---------------
--END WS SETS |
---------------
	
-- Midcast Sets
	sets.midcast.FastRecast = sets.precast.FC

-- Utsusemi Recast
	sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast,{back="Mujin Mantle"})

-- Unity Trust Shirt Buff
	sets.midcast['Apururu (UC)'] = {body="Apururu Unity Shirt"}

-- Ranged gear -- acc + TH
	sets.midcast.RA.TH = set_combine(sets.midcast.RA, set.TreasureHunter)
	sets.midcast.RA.Acc = sets.midcast.RA

-- Resting sets
	sets.resting = {}

-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle = {
	head="Lithelimb Cap",
	body="Emet Harness +1",
	hands="Kurys Gloves",
	legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
	feet={ name="Herculean Boots", augments={'Accuracy+26','"Triple Atk."+2','AGI+8',}},
	neck="Twilight Torque",
	waist="Flume Belt",
	left_ear="Infused Earring",
	right_ear="Reraise Earring",
	left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -6%','Magic dmg. taken -5%',}},
	right_ring="Karieyh Ring",
	back="Xucau Mantle"}

--
	sets.idle.Town = {
	main="Taming Sari",
	sub={ name="Sandung", augments={'Accuracy+50','Crit. hit rate+5%','"Triple Atk."+3',}},
	range="Wingcutter +1",
	head="Skulker's Bonnet +1",
	body={ name="Rawhide Vest", augments={'HP+50','"Subtle Blow"+7','"Triple Atk."+2',}},
	hands="Floral Gauntlets",
	legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
	feet="Herculean Boots",
	neck="Lissome Necklace",
	waist="Kentarch Belt +1",
	left_ear="Infused Earring",
	right_ear="Brutal Earring",
	left_ring="Karieyh Ring",
	right_ring="Rufescent Ring",
	back="Grounded Mantle"}
	
-- Defense sets
	sets.defense.Evasion = {}
	sets.defense.PDT = {}
	sets.defense.MDT = {}
	sets.Kiting = {}
	
-- Engaged Set
	-- Equip Haste = 25% (capped)
	-- Job Trait/Gift = 30% (Max)
	-- delay cap 80% (-25%-30% leave's us with 25DW to find in Base set to cap delay reduction) 
	sets.engaged = {ammo="Ginsen",
	head="Skulker's Bonnet +1",
	body={ name="Rawhide Vest", augments={'HP+50','"Subtle Blow"+7','"Triple Atk."+2',}},
	hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},
	legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
	feet={ name="Taeon Boots", augments={'Accuracy+20','"Dual Wield"+4','STR+4 DEX+4',}},
	neck="Lissome Necklace",
	waist="Kentarch Belt +1",
	left_ear="Dudgeon Earring",
	right_ear="Heartseeker Earring",
	left_ring="Epona's Ring",
	right_ring="Oneiros Ring",
	back={ name="Canny Cape", augments={'DEX+4','AGI+1','"Dual Wield"+5',}}}
	
	--If I switch into Accracy Mode Im not overly worried about delay caps as content im doin I just want to ensure TP gain.
	sets.engaged.Acc = set_combine(sets.engaged,{ammo="Honed Tathlum",
	head="Skulker's Bonnet +1",
	body={ name="Samnuha Coat", augments={'Mag. Acc.+12','"Mag.Atk.Bns."+12','"Dual Wield"+3',}},
	hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
	legs={ name="Taeon Tights", augments={'Accuracy+23','"Dual Wield"+4','DEX+8',}},
	neck="Subtlety Spec.",
	waist="Olseni Belt",
	feet="Herulean Boots",
	left_ring="Enlivened Ring",
	right_ring="Cacoethic Ring",
	back="Grounded Mantle",})

--I have left haste ACC adjustments in should you wish to use them
--5% Haste (haste samba from sub)--
	sets.engaged.Haste_5 = set_combine(sets.engaged, {left_ear="Suppanomimi",right_ear="Brutal Earring"})
	sets.engaged.Acc.Haste_5 = set_combine(sets.engaged.Acc, {})
--10%--
	sets.engaged.Haste_10 = set_combine(sets.engaged.Haste_5, {left_ear="Cessance Earring"})
	sets.engaged.Acc.Haste_10 = set_combine(sets.engaged.Acc.Haste_5, {})
-- 15 Haste --
	sets.engaged.Haste_15 = set_combine(sets.engaged.Haste_10, {back="Bleating Mantle"})
	sets.engaged.Acc.Haste_15 = set_combine(sets.engaged.Acc.Haste_10, {})
--20% haste--
	sets.engaged.Haste_20 = set_combine(sets.engaged.Haste_15, {hands="Adhemar Wristbands"})
	sets.engaged.Acc.Haste_20 = set_combine(sets.engaged.Acc.Haste_15, {})
-- 25% haste
	sets.engaged.Haste_25 = set_combine(sets.engaged.Haste_20, {feet="Herculean Boots"})
	sets.engaged.Acc.Haste_25 = set_combine(sets.engaged.Acc.Haste_20, {})
-- By this stage you should be none DW gear as it will reduce your TP gain per hit
-- 30% Haste
	sets.engaged.Haste_30 = set_combine(sets.engaged.Haste_25,{})
	sets.engaged.Acc.Haste_30 = set_combine(sets.engaged.Acc.Haste_25,{})
-- 35% Haste
	sets.engaged.Haste_35 = set_combine(sets.engaged.Haste_30,{})
	sets.engaged.Acc.Haste_35 = set_combine(sets.engaged.Acc.Haste_30,{})
--40% Haste
	sets.engaged.Haste_40 = set_combine(sets.engaged.Haste_35, {})
	sets.engaged.Acc.Haste_40 =  set_combine(sets.engaged.Acc.Haste_35,{})
--MaxHaste
	sets.engaged.MaxHaste = set_combine(sets.engaged.Haste_40, {})
	sets.engaged.Acc.MaxHaste =  set_combine(sets.engaged.Acc.Haste_40,{})

end
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
	if state.Buff[spell.english] ~= nil then
		state.Buff[spell.english] = true
	end
end
-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
		equip(sets.TreasureHunter)
	elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
		if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
			equip(sets.TreasureHunter)
		end
	end
	if spell.type == 'WeaponSkill' then
		if world.time >= (17*60) or world.time <= (5*60) then
			equip(sets.NightWS)
		else
			equip(sets.DayWS)
		end
	end
end
-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
		equip(sets.TreasureHunter)
	end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if state.Buff[spell.english] ~= nil then
		state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english]
	end
	
-- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
	if spell.type == 'WeaponSkill' and not spell.interrupted then
		state.Buff['Sneak Attack'] = false
		state.Buff['Trick Attack'] = false
		state.Buff['Feint'] = false
	end
end
-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
-- If Feint is active, put that gear set on on top of regular gear.
-- This includes overlaying SATA gear.
	check_buff('Feint', eventArgs)
end
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks.
-------------------------------------------------------------------------------------------------------------------
function get_custom_wsmode(spell, spellMap, defaut_wsmode)
	local wsmode
	
	if state.Buff['Sneak Attack'] then
		wsmode = 'SA'
	end
	if state.Buff['Trick Attack'] then
		wsmode = (wsmode or '') .. 'TA'
	end

	return wsmode
end
-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
-- Check that ranged slot is locked, if necessary
	check_range_lock()
	
-- Check for SATA when equipping gear.  If either is active, equip
-- that gear specifically, and block equipping default gear.
	check_buff('Sneak Attack', eventArgs)
	check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
	if player.hpp < 80 then
		idleSet = set_combine(idleSet, sets.idle.Regen)
	end

	return idleSet
end

function customize_melee_set(meleeSet)
	if state.TreasureMode.value == 'Fulltime' then
		meleeSet = set_combine(meleeSet, sets.TreasureHunter)
	end
	return meleeSet
end
-------------------------------------------------------------------------------------------------------------------
-- General hooks for change events.
-------------------------------------------------------------------------------------------------------------------
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
-- If we gain or lose any haste buffs, adjust which gear set we target.
-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		handle_equipping_gear(player.status)
	end
	if state.Buff[buff] ~= nil then
		state.Buff[buff] = gain
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end
end
-------------------------------------------------------------------------------------------------------------------
-- Various update events.
-------------------------------------------------------------------------------------------------------------------
-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	th_update(cmdParams, eventArgs)
	determine_haste_group()
end
-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
	local msg = 'Melee'
	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end
	
	msg = msg .. ': '
	msg = msg .. state.OffenseMode.value
	
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value
	end
	msg = msg .. ', WS: ' .. state.WeaponskillMode.value

	if state.DefenseMode.value ~= 'None' then
		msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
	end
	
	if state.Kiting.value == true then
		msg = msg .. ', Kiting'
	end
	
	if state.PCTargetMode.value ~= 'default' then
		msg = msg .. ', Target PC: '..state.PCTargetMode.value
	end

	if state.SelectNPCTargets.value == true then
		msg = msg .. ', Target NPCs'
	end

	msg = msg .. ', TH: ' .. state.TreasureMode.value
	add_to_chat(122, msg)
	eventArgs.handled = true
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
	if state.Buff[buff_name] then
		equip(sets.buff[buff_name] or {})
		if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
			equip(sets.TreasureHunter)
		end
		eventArgs.handled = true
	end
end

function determine_haste_group()

	classes.CustomMeleeGroups:clear()
-- assuming marches x 2 = 15%
-- Haste (white magic) 15%
-- Haste Samba (Sub) 5%
-- Haste (Merited DNC) 10% (never account for this)
-- Victory March 9.4/14%/15.6%/17.1% +0
-- Advancing March 6.3/10.9%/12.5%/14%  +0
-- Embrava 25%
-- buffactive[580] = geo haste
-- buffactive[33] = regular haste
-- state.HasteMode = toggle for when you know Haste II is being cast on you
-- Hi = Haste II is being cast. This is clunky to use when both haste II and haste I are being cast
-- but wtf can  you do..   I macro it, and use it often.
--[33]  = Haste
-- [370] = Haste Samba /sub
-- [580] = Geo/indi Haste
-- [214] = Brd March's
-- [228] = Embrava
-- [64]  = Last Resort end
	if state.HasteMode.value == 'Hi' then
		if	(((buffactive[580] or buffactive[33]) and buffactive.march == 2 or buffactive[224]) or (buffactive[33] and buffactive[224]) or (buffactive[224] and buffactive[370] and buffactive.march == 2)) then
			add_to_chat(8, '-------------MaxHaste%-------------')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif (((buffactive[580] or buffactive[33]) and buffactive.march == 1) or
			(buffactive.march == 2 and buffactive[228]) or
			(buffactive[228] and buffactive.march == 1 and buffactive[370])or
			(buffactive[33] and buffactive.march == 1)) then
			add_to_chat(8, '-------------Haste 40%-------------')
			classes.CustomMeleeGroups:append('Haste_40')
		elseif (((buffactive[33] or buffactive[580]) and buffactive[370]) or
			(buffactive[228] and buffactive.march == 1)) then
			add_to_chat(8, '-------------Haste 35%-------------')
			classes.CustomMeleeGroups:append('Haste_35')
		elseif buffactive[33] or buffactive[580] or
			(buffactive[228] and buffactive[370]) then
			add_to_chat(8, '-------------Haste 30%-------------')
			classes.CustomMeleeGroups:append('Haste_30')
		elseif buffactive[228] then
			add_to_chat(8, '-------------Haste 25%-------------')
			classes.CustomMeleeGroups:append('Haste_25')
		elseif (buffactive[370] and buffactive.march == 2) then
			add_to_chat(8, '-------------Haste 20%-------------')
			classes.CustomMeleeGroups:append('Haste_20')
		elseif (buffactive.march == 1 and buffactive[370])
			or buffactive.march == 2 then
			add_to_chat(8, '-------------Haste 15%-------------')
			classes.CustomMeleeGroups:append('Haste_15')
		elseif buffactive.march == 1 then
			add_to_chat(8, '-------------Haste 10%-------------')
			classes.CustomMeleeGroups:append('Haste_10')
		elseif buffactive[370] then
			add_to_chat(8, '-------------Haste 5%-------------')
			classes.CustomMeleeGroups:append('Haste_5')
		end
	else
		if	((buffactive[580] and (buffactive.march == 2 or buffactive[224] or buffactive[33]))
			or (buffactive[224] and buffactive[370] and buffactive.march == 2)) then
			add_to_chat(8, '-------------MaxHaste%-------------')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif (buffactive[580] and buffactive.march == 1) or
			(buffactive[228] and (buffactive[33] or buffactive.march == 2)) or
			(buffactive[228] and (buffactive.march == 1 and buffactive[370])) then
			add_to_chat(8, '-------------Haste 40%-------------')
			classes.CustomMeleeGroups:append('Haste_40')
		elseif (buffactive[580] and buffactive[370]) or
			(buffactive[228] and buffactive.march == 1) or (buffactive[370] and buffactive[33] and buffactive.march == 2) then
			add_to_chat(8, '-------------Haste 35%-------------')
			classes.CustomMeleeGroups:append('Haste_35')
		elseif buffactive[580] or
			(buffactive[228] and buffactive[370]) or (buffactive[33] and buffactive.march == 2) then
			add_to_chat(8, '-------------Haste 30%-------------')
			classes.CustomMeleeGroups:append('Haste_30')
		elseif buffactive[228] then
			add_to_chat(8, '-------------Haste 25%-------------')
			classes.CustomMeleeGroups:append('Haste_25')
		elseif ((buffactive[33] or buffactive.march == 2) and buffactive[370]) then
			add_to_chat(8, '-------------Haste 20%-------------')
			classes.CustomMeleeGroups:append('Haste_20')
		elseif  (buffactive[33] or buffactive.march == 2) or(buffactive.march == 1 and buffactive[370]) then
			add_to_chat(8, '-------------Haste 15%-------------')
			classes.CustomMeleeGroups:append('Haste_15')
		elseif buffactive.march == 1 then
			add_to_chat(8, '-------------Haste 10%-------------')
			classes.CustomMeleeGroups:append('Haste_10')
		elseif buffactive[370] then
			add_to_chat(8, '-------------Haste 5%-------------')
			classes.CustomMeleeGroups:append('Haste_5')
		end
	end
end
-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
	if category == 2 or -- any ranged attack
		--category == 4 or -- any magic action
		(category == 3 and param == 30) or -- Aeolian Edge
		(category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
		(category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
		then return true
	end
end
-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
	if player.equipment.range ~= 'empty' then
		disable('range', 'ammo')
	else
		enable('range', 'ammo')
	end
end
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(1, 7)
	elseif player.sub_job == 'WAR' then
		set_macro_page(1, 7)
	elseif player.sub_job == 'NIN' then
		set_macro_page(7, 1)
	else
	set_macro_page(7, 2)
	end
end
