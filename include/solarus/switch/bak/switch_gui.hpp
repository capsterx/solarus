
#pragma once

// Include Plutonium's main header
#include <pu/Plutonium>

// Define your main layout as a class inheriting from pu::Layout
class Solarus_GUI : public pu::ui::Layout
{
    public:

        Solarus_GUI();

        // Have ::Ref alias and ::New() static constructor
        void onInput(u64 Down, u64 Up, u64 Held, pu::ui::Touch Pos);
	//
        PU_SMART_CTOR(Solarus_GUI)

    private:

        // An easy way to keep objects is to have them as private members
        // Using ::Ref (of a Plutonium built-in object or any class having PU_SMART_CTOR) is an alias to a shared_ptr of the instance.
	std::vector<std::string> paths_;
        pu::ui::elm::Menu::Ref menu;

    public:
	std::string get_path() const;
	static std::string selected_path_;
};

// Define your application (can't instantiate base class, so need to make a derived one)
class MainApplication : public pu::ui::Application
{
    public:
        using Application::Application;
        PU_SMART_CTOR(MainApplication)

        // We need to define this, and use it to initialize everything
        void OnLoad() override;

    private:

        // Layout instance
        Solarus_GUI::Ref layout;
};
