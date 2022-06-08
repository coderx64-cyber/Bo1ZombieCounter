#include maps\_utility;
#include common_scripts\utility;

init()
{
    if ( GetDvar( #"zombiemode" ) == "1" )
        level thread onplayerconnect();
}

onplayerconnect()
{
    for (;;)
	{
        level waittill( "connected", player ); 
	    player thread onplayerspawned();
	}
}

onplayerspawned()
{
    self endon( "disconnect" );
	self waittill( "spawned_player" );
	self thread ZombieCounter();
	self thread HealthCounter();
}

ZombieCounter()
{
    hud = NewHudElem();
	hud.horzAlign = "right";
   	hud.vertAlign = "bottom";
   	hud.alignX = "right";
   	hud.alignY = "bottom";
   	hud.y = -20;
   	hud.x = -185;
   	hud.foreground = 1;
   	hud.fontscale = 8;
   	hud.alpha = 1;
   	hud.color = (1, 0, 0);
	hud SetValue(0);
	
	hud1 = NewHudElem();
	hud1.horzAlign = "right";
   	hud1.vertAlign = "bottom";
   	hud1.alignX = "right";
   	hud1.alignY = "bottom";
   	hud1.y = -20;
   	hud1.x = -210;
   	hud1.foreground = 1;
   	hud1.fontscale = 8;
   	hud1.alpha = 1;
   	hud1.color = (1, 0, 0);
	hud1 SetText("Zombie:");
	
	while (true)
	{
	    hud SetValue(get_enemy_count() + level.zombie_total);
		wait (0.1);
	}
}

HealthCounter()
{
    hud = NewHudElem();
	hud.horzAlign = "left";
   	hud.vertAlign = "bottom";
   	hud.alignX = "left";
   	hud.alignY = "bottom";
   	hud.y = -20;
   	hud.x = 260;
   	hud.foreground = 1;
   	hud.fontscale = 8;
   	hud.alpha = 1;
   	hud.color = (0, 0.5, 0);
	hud SetValue(0);
	
	hud1 = NewHudElem();
	hud1.horzAlign = "left";
   	hud1.vertAlign = "bottom";
   	hud1.alignX = "left";
   	hud1.alignY = "bottom";
   	hud1.y = -20;
   	hud1.x = 210;
   	hud1.foreground = 1;
   	hud1.fontscale = 8;
   	hud1.alpha = 1;
   	hud1.color = (0, 0.5, 0);
	hud1 SetText("Health:");
	
	while (true)
	{
	    hud SetValue(self.health);
		wait (0.1);
	}
}

get_enemy_count()
{
	enemies = [];
	valid_enemies = [];
	enemies = GetAiSpeciesArray( "axis", "all" );
	for( i = 0; i < enemies.size; i++ )
	{
		if ( is_true( enemies[i].ignore_enemy_count ) )
		{
			continue;
		}

		if( isDefined( enemies[i].animname ) )
		{
			valid_enemies = array_add( valid_enemies, enemies[i] );
		}
	}
	return valid_enemies.size;
}
