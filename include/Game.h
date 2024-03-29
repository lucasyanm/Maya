#ifndef GAME_H
#define GAME_H

#include "Renderer.h"
#include "Window.h"
#include "Player.h"

class Texture; 

class Game {
public:
    Game() { }
    ~Game() { }

    bool Init();
    void Run();
    void Render(float positionFactor);
    void Update();
    void Clean();
    void HandleEvents();
    bool running() { return _running; }

private:

    Window* _window;
    Renderer* _renderer;

    Player* _maya;

    unsigned int _lastFrame;

    bool _running;
};
#endif