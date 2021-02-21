#if 0
class Command_Line_Arguments
  : public brls::List
{
private:
    Command_Line_Arguments();

public:
    using std::function<std::string const &> = ValidateString;
    static ValidateString is_any();
    static ValidateString is_number();
    static ValidateString is_screen_size();
    static ValidateString is_path();

    static std::unique_ptr<Command_Line_Arguments> create();

    void add_enable_only(std::string const & argument, bool enabled);

    void enable_disable(
      std::string const & argument, 
      std::string const & enable="yes", 
      std::string const & disable="no", 
      bool enabled=false, 
      std::string const & description=argument
    );

    void add_choice(
      std::string const & argument, 
      std::vector<std::string> const & choices, 
      std::string const & description=argument
    );

    void add_string(
      std::string const & argument, 
      std::string const & default_, 
      std::string const & description = argument, 
      std::string const & description=argument, 
      ValidateString const & = is_any);

    std::pair<std::unique_pointer<char *>, int> get_argv() const nothrow;
    std::vector<std::string> get_arguments() const nothrow;
    std::map<std::string> get_argument_mapping() const nothrow;

private:
};

class Command_Line_Argument : 
  public brls::ListItem
{
public:
  Command_Line_Argument(
    std::string const & name,
    std::string const & value,
    std::string const & argument,
    std::shared_ptr<GameSettings> const & setting)
  : brls::ListItem(name)
  , argument_(argument)
  , settings_(setting)
  {
    this->setValue(value);
    this->getClickEvent()->subscribe([this](auto v){ this->do_change(v);});
    this->update_args();
  }

  void do_change(View * v)
  {
    change(v);
    update_args();
  }

  virtual void change(View*)=0;
  virtual void update_args() {
    (*settings_)[this->argument_ + "="] = this->getValue();
  }

protected:
  std::string argument_;
  std::shared_ptr<GameSettings> settings_;
};

class YesNoSetting :
  public  GameSetting
{
public:
  using GameSetting::GameSetting;

private:
  void change(View *) override
  {
    if (this->getValue() == "no")
    {
      this->setValue("yes");
    }
    else
    {
      this->setValue("no");
    }
  }
};

class EnableSetting : public YesNoSetting
{
public:
  using YesNoSetting::YesNoSetting;

private:
  void update_args()
  {
    if (getValue() == "no")
    {
      (*settings_).erase(this->argument_);
    }
    else
    {
      (*settings_)[this->argument_] = "";
    }
  }
};

class KeyboardSetting 
: public GameSetting
{
public:
  using GameSetting::GameSetting;
 
private: 
  void change(View *) override
  {
    this->setValue(get_keyboard_input(this->getValue()));
  }

  void update_args()
  {
    if (getValue() == "")
    {
      (*settings_).erase(this->argument_);
    }
    else
    {
      GameSetting::update_args();
    }
  }
};

#endif
