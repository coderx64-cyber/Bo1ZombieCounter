#include maps\_utility;
#include common_scripts\utility;

init()
{
    level.style = 0;
    level.bHealthBarRed = false;
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

    if (level.style == 0)
    {
        self thread ZombieCounter();
	    self thread HealthCounter();
    }
    else if (level.style == 1)
    {
        self thread ZombieCounter();
    }
    else if (level.style == 2)
    {
        self thread HealthCounter();
    }
    else if (level.style == 3)
    {
        self thread ZombieCounter();
        self thread HealthBar();
    }
    else if (level.style == 4)
    {
        self thread HealthBar();
    }
}

ZombieCounter()
{
    hud = NewHudElem();
    hud1 = NewHudElem();

    if (level.style == 1 || level.style == 3)
    {
        hud.horzAlign = "center";
   	    hud.alignX = "center";
   	    hud.y = -20;
   	    hud.x = 50;

   	    hud1.horzAlign = "center";
   	    hud1.alignX = "center";
   	    hud1.y = -20;
   	    hud1.x = 0;
    }
    else
    {
        hud.horzAlign = "right";
   	    hud.alignX = "right";
   	    hud.y = -20;
   	    hud.x = -195;

   	    hud1.horzAlign = "right";
   	    hud1.alignX = "right";
   	    hud1.y = -20;
   	    hud1.x = -210;
    }

    hud.vertAlign = "bottom";
    hud.alignY = "bottom";
   	hud.foreground = 1;
   	hud.fontscale = 8;
   	hud.alpha = 1;
   	hud.color = (1, 0, 0);
	hud SetValue(0);
	
	hud1.vertAlign = "bottom";
	hud1.alignY = "bottom";
   	hud1.foreground = 1;
   	hud1.fontscale = 8;
   	hud1.alpha = 1;
   	hud1.color = (1, 0, 0);
	hud1 SetText("Zombies Left:");
	
	while (true)
	{
	    if (level.style == 1 || level.style == 3)
            hud.x = (string(get_enemy_count() + level.zombie_total).size * 5) + 50;
        else
            hud.x = (string(get_enemy_count() + level.zombie_total).size * 5) + -195;

	    hud SetValue(get_enemy_count() + level.zombie_total);

        if (get_enemy_count() + level.zombie_total == 0)
        {
            hud.color = (0.5, 0, 1);
            hud1.color = (0.5, 0, 1);
        }
        else
        {
            hud.color = (1, 0, 0);
            hud1.color = (1, 0, 0);
        }

		wait (0.1);
	}
}

HealthCounter()
{
    hud = NewHudElem();
    hud1 = NewHudElem();

    if (level.style == 2)
    {
        hud.horzAlign = "center";
   	    hud.alignX = "center";
   	    hud.y = -20;
   	    hud.x = 30;

   	    hud1.horzAlign = "center";
   	    hud1.alignX = "center";
   	    hud1.y = -20;
   	    hud1.x = 0;
    }
    else
    {
        hud.horzAlign = "left";
   	    hud.alignX = "right";
   	    hud.y = -20;
   	    hud.x = 225;

   	    hud1.horzAlign = "left";
   	    hud1.alignX = "right";
   	    hud1.y = -20;
   	    hud1.x = 210;
    }

    hud.vertAlign = "bottom";
    hud.alignY = "bottom";
   	hud.foreground = 1;
   	hud.fontscale = 8;
   	hud.alpha = 1;
   	hud.color = (0, 0.5, 0);
	hud SetValue(0);
	
	hud1.vertAlign = "bottom";
    hud1.alignY = "bottom";
   	hud1.foreground = 1;
   	hud1.fontscale = 8;
   	hud1.alpha = 1;
   	hud1.color = (0, 0.5, 0);
	hud1 SetText("Health:");
	
    if (!isDefined(self.maxhealth) || self.maxhealth <= 0)
    {
        self.maxhealth = 100;
    }

	while (true)
	{
	    if (level.style == 2)
            hud.x = (string(self.health).size * 5) + 30;
        else
            hud.x = (string(self.health).size * 5) + 225;

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

HealthBar()
{
    hud = NewHudElem();
    hud.horzalign = "left";
    hud.vertalign = "bottom";
    hud.alignx = "left";
    hud.aligny = "bottom";
    hud.x = 40;
    hud.y = -105;
    hud.foreground = 1;
    hud.alpha = 1;
    hud setshader( "white", 1, 12 );
    if (level.bHealthBarRed == true)
        hud.color = (1, 0, 0);
    else
        hud.color = (0, 1, 0);

    hud1 = NewHudElem();
    hud1.horzalign = "left";
    hud1.vertalign = "bottom";
    hud1.alignx = "left";
    hud1.aligny = "bottom";
    hud1.x = 33;
    hud1.y = -100;
    hud1.foreground = 1;
    hud1.alpha = 1;
    hud1 setshader( "black", 115, 20 );
    hud1.color = (0, 1, 0);

    hud2 = NewHudElem();
    hud2.horzalign = "left";
    hud2.vertalign = "bottom";
    hud2.alignx = "left";
    hud2.aligny = "bottom";
    hud2.x = 5;
    hud2.y = -102;
    hud2.foreground = 1;
    hud2.fontscale = 8;
    hud2.alpha = 1;
    if (level.bHealthBarRed == true)
        hud2.color = (1, 0, 0);
    else
        hud2.color = (0, 1, 0);

    if (!isDefined(self.maxhealth) || self.maxhealth <= 0)
    {
        self.maxhealth = 100;
    }

    while (true)
    {
        width = int(max((self.health / self.maxhealth) * 100, 1));
        hud SetShader( "white", width, 12 );
        hud2 SetValue(self.health);
        wait (0.1);
    }
}
