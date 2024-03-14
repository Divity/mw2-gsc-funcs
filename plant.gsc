monitorBomb(){
    level endon("game_ended");
    level waittill("connected", player);
    
    for(;;){        
        timePassed = (getTime() - level.startTime)/1000;
        timeRemaining = (getTimeLimit() * 60) - timePassed;

        if ( timeRemaining <= 2 ){
			/* CUSTOM MAPS DON'T HAVE BOMBS, SO KILL THE BOTS IN THAT CASE INSTEAD*/
            if( isDefined(level.bombzones) ){
                thread defuseBomb();
                doPlant();return;
            }else{
                one_to_win = getWatchedDvar( "winlimit" ) - 1;  

                if(game["roundsWon"]["axis"] < one_to_win){
					foreach(p in level.players)
						p iPrintLn("Killing all the bots...");

                    foreach(player in level.players){
                        if(player.pers["team"] == "allies")
                            player suicide();
                    }    
                }
				return;
            }
        }wait 1;
    }
}

doPlant(){	
	if ( !level.bombplanted ){
		thread bomb_sound();
		thread maps\mp\gametypes\sd::bombplanted(level.bombzones[1], undefined);			
		level.bombZones[0] maps\mp\gametypes\_gameobjects::disableObject();
	}
}

defuseBomb(){
	level endon("game_ended");
	
	one_to_win = getWatchedDvar( "winlimit" ) - 1;
	
	wait level.bombTimer - 1;
	
	if(game["roundsWon"]["axis"] == one_to_win && game["roundsWon"]["allies"] < one_to_win ){
		leaderDialog( "bomb_defused" );
		level notify("defused");
		level maps\mp\gametypes\sd::bombDefused();
	}
}

bomb_sound(){	
	level endon("defused");
	
	foreach(player in level.players)
		player playLocalSound( "mp_bomb_plant" );

	leaderDialog( "bomb_planted" );
	wait level.bombTimer - .1;
	
	if(!level.gameEnded){
		foreach(player in level.players)
			player playSound("exp_suitcase_bomb_main");
	}
}
