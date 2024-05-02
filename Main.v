module main

import gg
import gx

const bg_color = gx.black
const nb_player_max = 2

//______________UI______________
const colors = [gx.red, gx.blue]


const scale = 1

const chunk_size = 20.0 // doit être 2*le radius du plus grand
const div_chunk_size = 1/f64(chunk_size)

struct App {
mut:
	gg &gg.Context = unsafe { nil }

	game		bool
	death_screen_time int
	
	win_width	f64
	win_height	f64
	text_cfg	gx.TextCfg
	bouton_cfg	gx.TextCfg

	players_list	[]Player
	player_nb		int
	center_list		[]Center

	attaques			[]Attaques

	score	[]int
	bouton_list []Vector
}

fn main() {

	mut app := &App{}
	app.gg = gg.new_context(
		fullscreen: false
		width: 700
		height: 700
		create_window: true
		window_title: '- Orbites -'
		user_data: app
		bg_color: bg_color
		init_fn:  on_init
		frame_fn: on_frame
		event_fn: on_event
		sample_count: 4
	)
	app.gg.run()
}

fn on_init(mut app App) {
	app.player_nb = 1
	app.game = false
	app.gg.begin()

	app.score = [0]

	size := app.gg.window_size()
	app.win_width 		= size.width
	app.win_height 		= size.height

	app.text_cfg = gx.TextCfg{gx.black, 16, .left, .top, 100, "", false, false, false}
	app.bouton_cfg = gx.TextCfg{gx.black, 16, .center, .middle, 100, "", false, false, false}

	// BOUTONS
	app.bouton_list << [Vector{app.win_width/2 - 100, app.win_height/2  - 30, 0}, Vector{app.win_width/2 + 100, app.win_height/2  - 30, 0}]

	app.gg.end()
}

fn on_event(e &gg.Event, mut app App) {
	match e.typ {
		.key_down {
			match e.key_code {
				.escape {
					app.gg.quit()
				}
				.s {
					if app.game{
						if app.players_list[0].center > 0 && app.game{
							app.players_list[0].center_changer(-1 ,app)
						}
					}
				}
				.d {
					if app.game{
						if app.players_list[0].center < app.center_list.len -1{
							app.players_list[0].center_changer(1 ,app)
						}
					}
				}
				.f {
					if app.game{
						app.players_list[0].temps_tour = -app.players_list[0].temps_tour
					}
					
				}
				.j {
					if app.player_nb > 1 && app.game{
						if app.players_list[1].center > 0{
							app.players_list[1].center_changer(-1 ,app)
						}
					}	
				}
				.k {
					if app.player_nb > 1 && app.game{
						if app.players_list[1].center < app.center_list.len -1{
							app.players_list[1].center_changer(1 ,app)
						}
					}
					
				}
				.l {
					if app.player_nb > 1 && app.game{
						app.players_list[1].temps_tour = -app.players_list[1].temps_tour
					}
				}
				.y {
					if app.player_nb < nb_player_max && !app.game{
						app.player_nb += 1
					}
				}
				.t {
					if app.player_nb > 1 && !app.game{
						app.player_nb -= 1
					}					
				}
				.space {
					if !app.game{
						app.game_start()
					}
				}
				else {}
			}
		}
		.mouse_down{
			match e.mouse_button {
				.left{
					app.check_boutons(e.mouse_x, e.mouse_y)
				}
				else{}
			}
		}
		else{}
	}
}
