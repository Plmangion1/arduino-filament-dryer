// Filament Dryer Box Controller
// Sensors: DS18B20 "heater" probe on D2, DHT11/22 "tub" sensor on D3
// Outputs: Relay1 (D4) = heater, Relay2 (D5) = fan
// LCD: I2C 16x2 (A4/A5) with custom icons for heater/fan status

#include <OneWire.h>
#include <DallasTemperature.h>
#include <DHT.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

#define HEATER_PROBE_PIN 2
#define TUB_DHT_PIN      3
#define RELAY_HEATER     4
#define RELAY_FAN        5

#define DHTTYPE DHT11

OneWire oneWire(HEATER_PROBE_PIN);
DallasTemperature heaterSensor(&oneWire);
DHT tubSensor(TUB_DHT_PIN, DHTTYPE);
LiquidCrystal_I2C lcd(0x27, 16, 2);

const float HEAT_OFF_TEMP = 40.0;
const float HEAT_HYST     = 10.0;
const float FAN_ON_TEMP   = 20.0;
const float FAN_HYST      = 0.3;

bool heaterOn = false;
bool fanOn = false;

byte flameOn[8] = {
  0b00100,
  0b00100,
  0b01010,
  0b01010,
  0b10001,
  0b10001,
  0b01110,
  0b00000
};

byte flameOff[8] = {
  0b00000,
  0b00000,
  0b01110,
  0b01010,
  0b01010,
  0b01110,
  0b00000,
  0b00000
};

byte fanOnIcon[8] = {
  0b00000,
  0b10101,
  0b01110,
  0b11111,
  0b01110,
  0b10101,
  0b00000,
  0b00000
};

byte fanOffIcon[8] = {
  0b00000,
  0b00000,
  0b01110,
  0b01010,
  0b01110,
  0b00000,
  0b00000,
  0b00000
};

void setup() {
  Serial.begin(9600);
  pinMode(RELAY_HEATER, OUTPUT);
  pinMode(RELAY_FAN, OUTPUT);
  digitalWrite(RELAY_HEATER, LOW);
  digitalWrite(RELAY_FAN, LOW);

  heaterSensor.begin();
  tubSensor.begin();

  lcd.init();
  lcd.backlight();

  lcd.createChar(0, flameOn);
  lcd.createChar(1, flameOff);
  lcd.createChar(2, fanOnIcon);
  lcd.createChar(3, fanOffIcon);
}

void loop() {
  heaterSensor.requestTemperatures();
  float heaterTemp = heaterSensor.getTempCByIndex(0);

  float tubTemp = tubSensor.readTemperature();
  float tubHum  = tubSensor.readHumidity();

  if (heaterTemp >= HEAT_OFF_TEMP) {
    heaterOn = false;
  } else if (heaterTemp < (HEAT_OFF_TEMP - HEAT_HYST)) {
    heaterOn = true;
  }
  digitalWrite(RELAY_HEATER, heaterOn ? HIGH : LOW);

  if (heaterTemp >= FAN_ON_TEMP) {
    fanOn = true;
  } else if (heaterTemp < (FAN_ON_TEMP - FAN_HYST)) {
    fanOn = false;
  }
  digitalWrite(RELAY_FAN, fanOn ? HIGH : LOW);

  lcd.setCursor(0, 0);
  lcd.write(heaterOn ? byte(0) : byte(1));
  lcd.print(" H:");
  lcd.print(heaterTemp, 1);
  lcd.print("C ");
  lcd.setCursor(13, 0);
  lcd.write(fanOn ? byte(2) : byte(3));
  lcd.print("   ");

  lcd.setCursor(0, 1);
  lcd.print("T:");
  lcd.print(tubTemp, 1);
  lcd.print("C ");
  lcd.print(tubHum, 0);
  lcd.print("%   ");

  Serial.print("Heater probe: ");
  Serial.print(heaterTemp);
  Serial.print(" | Tub: ");
  Serial.print(tubTemp);
  Serial.print("C ");
  Serial.print(tubHum);
  Serial.print("%");
  Serial.print(" | Heater relay: ");
  Serial.print(heaterOn);
  Serial.print(" | Fan relay: ");
  Serial.println(fanOn);

  delay(2000);
}
