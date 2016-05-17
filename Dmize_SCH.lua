-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
        Custom commands:

        Shorthand versions for each strategem type that uses the version appropriate for
        the current Arts.

                                        Light Arts              Dark Arts

        gs c scholar light              Light Arts/Addendum
        gs c scholar dark                                       Dark Arts/Addendum
        gs c scholar cost               Penury                  Parsimony
        gs c scholar speed              Celerity                Alacrity
        gs c scholar aoe                Accession               Manifestation
        gs c scholar power              Rapture                 Ebullience
        gs c scholar duration           Perpetuance
        gs c scholar accuracy           Altruism                Focalization
        gs c scholar enmity             Tranquility             Equanimity
        gs c scholar skillchain                                 Immanence
        gs c scholar addendum           Addendum: White         Addendum: Black
--]]



-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    update_active_strategems()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

state.MagicBurst = M(false, 'Magic Burst')
    select_default_macro_book()
	send_command('bind ^B gs c toggle MagicBurst')
end

function user_unload()
	send_command('unbind ^M')

end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Precast sets to enhance JAs
	sets.precast['Apururu (UC)'] = {} --< Apururu Unity Shirt
	sets.precast.JA['Tabula Rasa'] = {}
	sets.precast.JA['Enlightenment'] = {} --< Peda. Gown +1
	sets.precast.JA['Light Arts'] = {} --< Acad. Pants +1
	sets.precast.JA['Dark Arts'] = {} --< Acad. Gown +1
	sets.precast.JA['Immanence'] = {} --< Arbatel Bracers +1
	sets.precast.JA['Ebullience'] = {} --< Savants Bonnet + 2
	sets.precast.JA['Rapture'] = {} --< Savant's Bonnet +2
	sets.precast.JA['Perpetuance'] = {} --< Arbatel Bracer's +1

    -- Fast cast sets for spells

	--< plenty of pieces you can get to improve this Buddy 
    sets.precast.FC = {
    main={ name="Coeus", augments={'Mag. Acc.+50','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
    sub="Vivid Strap",
    ammo="Sapience Orb",
    head="Welkin Crown",
    body="Vanir Cotehardie",
    legs="Orvail Pants +1",
    left_ear="Loquac. Earring",
	waist="Channeler's Stone",
    back="Swith Cape",
}


    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {}) --< Seigel Sash
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {}) --< Stoicheion Medal,Barkarole Earring
	sets.precast.FC.Helix = sets.precast.FC['Elemental Magic']
	
    sets.precast.FC.Cure = set_combine(sets.precast.FC,{back="Pahtli Cape"})	--< Lots you can add to this to reduce cure cast time
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {}) --< Twilight Cloak
	sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {hands="Carapacho cuffs"})


    -- Midcast Sets

	sets.midcast['Apururu (UC)'] = {} --< Apururu Unity Shirt
    sets.midcast.FastRecast = set_combine(sets.precast.FC, {feet="Merlinic Crackows",hands="Lurid Mitts"})

    sets.midcast.Cure = {
    main={ name="Nibiru Cudgel", augments={'MP+50','INT+10','"Mag.Atk.Bns."+15',}},
    ammo="Hydrocera",
    head="Welkin Crown",
    body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
    hands="Telchine Gloves",
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Melic Torque",
    waist="Channeler's Stone",
    left_ear="Loquac. Earring",
    right_ear="Magnetic Earring",
    left_ring="Mediator's Ring",
    right_ring={ name="Dark Ring", augments={'Enemy crit. hit rate -1','Spell interruption rate down -3%','Phys. dmg. taken -4%',}},
    back="Pahtli Cape",
}

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Regen = {
    main={ name="Coeus", augments={'Mag. Acc.+50','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
    sub="Vivid Strap",
    ammo="Hydrocera",
    head="Welkin Crown",
    body="Telchine Chas.",
    hands={ name="Psycloth Manillas", augments={'MP+37','INT+5','"Conserve MP"+4',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Melic Torque",
    waist="Channeler's Stone",
    left_ear="Loquac. Earring",
    right_ear="Magnetic Earring",
    left_ring="Mediator's Ring",
    right_ring={ name="Dark Ring", augments={'Enemy crit. hit rate -1','Spell interruption rate down -3%','Phys. dmg. taken -4%',}},
    back="Gwyddion's Cape",
}

    sets.midcast.Cursna = {
    main={ name="Coeus", augments={'Mag. Acc.+50','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
    sub="Vivid Strap",
    ammo="Hydrocera",
    head="Welkin Crown",
    body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
    hands={ name="Psycloth Manillas", augments={'MP+37','INT+5','"Conserve MP"+4',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Melic Torque",
    waist="Channeler's Stone",
    left_ear="Loquac. Earring",
    right_ear="Magnetic Earring",
    left_ring="Mediator's Ring",
    right_ring={ name="Dark Ring", augments={'Enemy crit. hit rate -1','Spell interruption rate down -3%','Phys. dmg. taken -4%',}},
    back="Gwyddion's Cape",
}

    sets.midcast['Enhancing Magic'] =  sets.midcast.Regen

	sets.midcast.Stoneskin = sets.midcast['Enhancing Magic']

	sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'],{}) --< Peda Loafers +1
	sets.midcast.Haste = set_combine(sets.midcast['Enhancing Magic'],{})
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'],{})
	sets.midcast.Protect = sets.midcast.Haste
	sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = sets.midcast.Haste
    sets.midcast.Shellra = sets.midcast.Shell


    -- Custom spell classes
    sets.midcast.MndEnfeebles = {
    main={ name="Coeus", augments={'Mag. Acc.+50','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
    sub="Elder's Grip +1",
    ammo="Hydrocera",
    head="Telchine Cap",
    body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
    hands="Lurid Mitts",
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Enfeebling Torque",
    waist="Aswang Sash",
    left_ear="Loquac. Earring",
    right_ear="Magnetic Earring",
    left_ring="Mediator's Ring",
    right_ring={ name="Dark Ring", augments={'Enemy crit. hit rate -1','Spell interruption rate down -3%','Phys. dmg. taken -4%',}},
    back="Gwyddion's Cape",
}

sets.midcast.Helix = {
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Elder's Grip +1",
    ammo="Witchstone",
    head="Welkin Crown",
    body={ name="Psycloth Vest", augments={'Elem. magic skill +20','INT+7','Enmity-6',}},
    hands={ name="Psycloth Manillas", augments={'MP+37','INT+5','"Conserve MP"+4',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Quanpur Necklace",
    waist="Aswang Sash",
    left_ear="Friomisi Earring",
    right_ear="Hecate's Earring",
    left_ring="Mediator's Ring",
    right_ring="Shiva Ring",
    back="Toro Cape",
}

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles,{waist="Channeler's Stone",right_ring="Shiva Ring",})

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

    sets.midcast['Dark Magic'] = {
    main={ name="Coeus", augments={'Mag. Acc.+50','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
    sub="Elder's Grip +1",
    ammo="Hydrocera",
    head="Welkin Crown",
    body={ name="Psycloth Vest", augments={'Elem. magic skill +20','INT+7','Enmity-6',}},
    hands={ name="Psycloth Manillas", augments={'MP+37','INT+5','"Conserve MP"+4',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Dark Torque",
    waist="Aswang Sash",
    left_ear="Friomisi Earring",
    right_ear="Hecate's Earring",
    left_ring="Mediator's Ring",
    right_ring="Shiva Ring",
    back="Gwyddion's Cape",
}

    sets.midcast.Kaustra =  {
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Elder's Grip +1",
    ammo="Witchstone",
    head="Welkin Crown",
    body={ name="Psycloth Vest", augments={'Elem. magic skill +20','INT+7','Enmity-6',}},
    hands={ name="Psycloth Manillas", augments={'MP+37','INT+5','"Conserve MP"+4',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Quanpur Necklace",
    waist="Aswang Sash",
    left_ear="Friomisi Earring",
    right_ear="Hecate's Earring",
    left_ring="Mediator's Ring",
    right_ring="Shiva Ring",
    back="Toro Cape",
}

    sets.midcast.Drain = {
    main={ name="Coeus", augments={'Mag. Acc.+50','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
    sub="Elder's Grip +1",
    ammo="Hydrocera",
    head="Welkin Crown",
    body={ name="Psycloth Vest", augments={'Elem. magic skill +20','INT+7','Enmity-6',}},
    hands={ name="Psycloth Manillas", augments={'MP+37','INT+5','"Conserve MP"+4',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Quanpur Necklace",
    waist="Aswang Sash",
    left_ear="Friomisi Earring",
    right_ear="Hecate's Earring",
    left_ring="Mediator's Ring",
    right_ring="Shiva Ring",
    back="Gwyddion's Cape",
}

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = sets.midcast.IntEnfeebles

    -- Elemental Magic sets are default for handling low-tier nukes.
    sets.midcast['Elemental Magic'] = {
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Elder's Grip +1",
    ammo="Witchstone",
    head="Welkin Crown",
    body={ name="Psycloth Vest", augments={'Elem. magic skill +20','INT+7','Enmity-6',}},
    hands={ name="Psycloth Manillas", augments={'MP+37','INT+5','"Conserve MP"+4',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Quanpur Necklace",
    waist="Aswang Sash",
    left_ear="Friomisi Earring",
    right_ear="Hecate's Earring",
    left_ring="Mediator's Ring",
    right_ring="Shiva Ring",
    back="Toro Cape",
}

sets.magic_burst = set_combine(sets.midcast['Elemental Magic'],{})

    sets.midcast.Impact = {} --< Need Twilight Cloak Befor you worry about this


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
    main="Boonwell Staff",
    sub="Elder's Grip +1",
    ammo="Hydrocera",
    head="Hike Khat",
    body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
    hands="Telchine Gloves",
    legs="Assiduity Pants",
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Quanpur Necklace",
    waist="Aswang Sash",
    left_ear="Loquac. Earring",
    right_ear="Magnetic Earring",
    left_ring="Mediator's Ring",
    right_ring="Defending Ring",
    back="Iximulew Cape",
}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
    main={ name="Coeus", augments={'Mag. Acc.+50','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
    sub="Vivid Strap",
    ammo="Hydrocera",
    head="Hike Khat",
    body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
    hands="Lurid Mitts",
    legs="Assiduity Pants",
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Warder's Charm",
    waist="Aswang Sash",
    left_ear="Loquac. Earring",
    right_ear="Magnetic Earring",
    left_ring={ name="Dark Ring", augments={'Enemy crit. hit rate -1','Spell interruption rate down -3%','Phys. dmg. taken -4%',}},
    right_ring="Defending Ring",
    back="Iximulew Cape",
}

sets.idle.Town = {
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Elder's Grip +1",
    ammo="Hydrocera",
    head="Welkin Crown",
    body={ name="Psycloth Vest", augments={'Elem. magic skill +20','INT+7','Enmity-6',}},
    hands="Lurid Mitts",
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+2','"Mag.Atk.Bns."+10',}},
    neck="Melic Torque",
    waist="Channeler's Stone",
    left_ear="Loquac. Earring",
    right_ear="Friomisi Earring",
    left_ring={ name="Dark Ring", augments={'Enemy crit. hit rate -1','Spell interruption rate down -3%','Phys. dmg. taken -4%',}},
    right_ring="Defending Ring",
    back="Iximulew Cape",
}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {}



    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
 	sets.buff['Ebullience'] = {}
	sets.buff['Rapture'] = {}
	sets.buff['Perpetuance'] = {}
	sets.buff['Immanence'] = { }
	sets.buff['Penury'] = {}
	sets.buff['Parsimony'] = {}
	sets.buff['Celerity'] = {}
	sets.buff['Alacrity'] = {}
	sets.buff['Stormsurge'] = {}
	sets.buff['Klimaform'] = {}
	
    sets.buff.FullSublimation = {}
    sets.buff.PDTSublimation = {}

    --sets.buff['Sandstorm'] = {feet="Desert Boots"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
    end
	
	if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value then
        equip(sets.magic_burst)
        end
		if spell.element == world.day_element or spell.element == world.weather_element then
        equip ({})
    end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
	if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if state.Buff['Sublimation: Activated'] then
        if state.IdleMode.value == 'Normal' then
            idleSet = set_combine(idleSet, sets.buff.FullSublimation)
        elseif state.IdleMode.value == 'PDT' then
            idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
        end
    end

    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not (buffactive['light arts']      or buffactive['dark arts'] or
                       buffactive['addendum: white'] or buffactive['addendum: black']) then
        if state.IdleMode.value == 'Stun' then
            send_command('@input /ja "Dark Arts" <me>')
        else
            send_command('@input /ja "Light Arts" <me>')
        end
    end

    update_active_strategems()
    update_sublimation()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false
    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Buff.Immanence then
            equip(sets.buff['Immanence'])
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end

    end

    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
end


-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end


-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]

    local maxStrategems = (player.main_job_level + 10) / 20

    local fullRechargeTime = 4*60

    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

    return currentCharges
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 9)
end

