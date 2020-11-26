-- aaaa

local play_rate = 1
local current_position=0
local duration = 0

function init()

  -- initialize softcut
  for i=1,1 do
    softcut.enable(i,1)
    softcut.level(i,1)
    softcut.pan(i,0)
    softcut.rate(i,1)
    softcut.loop(i,1)
    softcut.rec(i,0)
    softcut.buffer(i,1)
    softcut.position(i,0)
    softcut.level_slew_time(i,4)
    softcut.rate_slew_time(i,0.5)
    softcut.post_filter_dry(i,0.0)
    softcut.post_filter_lp(i,1.0)
    softcut.post_filter_rq(i,0.3)
    softcut.post_filter_fc(i,44100)
  end
  softcut.phase_quant(1,0.025)

  -- position poll
  softcut.event_phase(update_positions)
  softcut.poll_start_phase()

  load_file("/home/we/dust/code/turntable/loop1.wav")
end


function update_positions(i,x)
	current_position = x
end


function enc(n,x)
	-- any encoder will do 

  -- TODO: change how "fast" this moves the position
	current_position = current_position + x/10
	if current_position > duration then 
		current_position = 0
	elseif current_position < 0 then 
		current_position = duration 
	end
	softcut.position(1,current_position)
end


function load_file(file)
  print("loading "..file)
  softcut.buffer_clear_region(1,-1)
  local ch,samples,samplerate=audio.file_info(file)
  play_rate=samplerate/48000.0 -- compensate for files that aren't 48Khz
  duration=samples/48000.0
  softcut.buffer_read_mono(file,0,0,-1,1,1)
  print("loaded "..file.." sr="..samplerate..", duration="..duration)
  softcut.loop_start(1,0)
  softcut.loop_end(1,duration)
  softcut.loop(1,1)
  softcut.rate(1,play_rate)
  softcut.play(1,1)
end

