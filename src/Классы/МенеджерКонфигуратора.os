#Использовать v8runner
#Использовать asserts

Перем Лог;
Перем УправлениеКонфигуратором;
Перем КаталогВременнойИБ;

Функция УправлениеКонфигуратором() Экспорт
	Возврат УправлениеКонфигуратором;	
КонецФункции

Процедура Инициализация(Знач СтрокаПодключения, Знач Пользователь="", Знач Пароль="",
						Знач ВерсияПлатформы="", Знач КлючРазрешенияЗапуска = "", 
						Знач КодЯзыка = "", Знач КодЯзыкаСеанса = "") Экспорт

	ТекущаяПроцедура = "Инициализация";
	Ожидаем.Что(СтрокаПодключения, ТекущаяПроцедура+": не задана строка подключения").Заполнено();	
	
	УправлениеКонфигуратором = Новый УправлениеКонфигуратором();

	КаталогВременнойИБ = ВременныеФайлы.СоздатьКаталог();
	УправлениеКонфигуратором.КаталогСборки(КаталогВременнойИБ);
		
	УправлениеКонфигуратором.УстановитьКонтекст(СтрокаПодключения, Пользователь, Пароль);
	Если НЕ ПустаяСтрока(ВерсияПлатформы) Тогда
		УправлениеКонфигуратором.ИспользоватьВерсиюПлатформы(ВерсияПлатформы);
	КонецЕсли;
	
	Если Не ПустаяСтрока(КлючРазрешенияЗапуска) Тогда
		УправлениеКонфигуратором.УстановитьКлючРазрешенияЗапуска(КлючРазрешенияЗапуска);
	КонецЕсли;	

	Если ЗначениеЗаполнено(КодЯзыка) Тогда
		УправлениеКонфигуратором.УстановитьКодЯзыка(КодЯзыка);
	КонецЕсли;

	Если ЗначениеЗаполнено(КодЯзыкаСеанса) Тогда
		УправлениеКонфигуратором.УстановитьКодЯзыкаСеанса(КодЯзыка);
	КонецЕсли;

КонецПроцедуры

Процедура Деструктор() Экспорт
	Попытка
		Если КаталогВременнойИБ <> Неопределено Тогда
			ВременныеФайлы.УдалитьФайл(КаталогВременнойИБ);
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	КаталогВременнойИБ = Неопределено;
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//   ДополнительныеКлючиЗапуска - <Тип.Вид> - <описание параметра>
//
Процедура ОбновитьКонфигурациюБазыДанных(Знач ДополнительныеКлючиЗапуска = "") Экспорт
										

	Лог.Информация("Запускаю обновление конфигурации БД");
	ТекущаяПроцедура = "ОбновитьКонфигурациюБазыДанных";
	
	Если Не ПустаяСтрока(ДополнительныеКлючиЗапуска) Тогда

	КонецЕсли;

	Попытка
		УправлениеКонфигуратором.ОбновитьКонфигурациюБазыДанных(Ложь);
		Текст = УправлениеКонфигуратором.ВыводКоманды();
		Если Не ПустаяСтрока(Текст) Тогда
			Лог.Информация(Текст);
		КонецЕсли;
	Исключение
		Лог.Ошибка(УправлениеКонфигуратором.ВыводКоманды());
		ВызватьИсключение ТекущаяПроцедура;
	КонецПопытки;

	Лог.Информация("Обновление конфигурации БД завершено.");

КонецПроцедуры //ОбновитьКонфигурациюБазыДанных

// <Описание процедуры>
//
// Параметры:
//   ИмяРасширения - <Строка> - <описание параметра>
//   ДополнительныеКлючиЗапуска - <Тип.Вид> - <описание параметра>
//
Процедура ОбновитьРасширение(Знач ИмяРасширения, Знач ДополнительныеКлючиЗапуска = "") Экспорт
	ТекущаяПроцедура = "ОбновитьРасширение";

	Лог.Информация("Запускаю обновление расширения %1", ИмяРасширения);

	Попытка
		УправлениеКонфигуратором.ОбновитьКонфигурациюБазыДанных(Ложь, Ложь, Ложь, ИмяРасширения);
		Текст = УправлениеКонфигуратором.ВыводКоманды();
		Если Не ПустаяСтрока(Текст) Тогда
			Лог.Информация(Текст);
		КонецЕсли;
	Исключение
		Лог.Ошибка(УправлениеКонфигуратором.ВыводКоманды());
		ВызватьИсключение ТекущаяПроцедура;
	КонецПопытки;

	Лог.Информация("Обновление расширения завершено.");

КонецПроцедуры //ОбновитьРасширение

// TODO в v8runner и vanessa-runner выделить отдельную команду для показа всех расширений конфигурации
Процедура ПоказатьСписокВсехРасширенийКонфигурации() Экспорт

	ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/Visible");
	ПараметрыЗапуска.Добавить("/DumpDBCfgList");
	ПараметрыЗапуска.Добавить("-AllExtensions");
	УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Лог.Информация("Список расширений конфигурации:%2%1", УправлениеКонфигуратором.ВыводКоманды(), Символы.ПС);
КонецПроцедуры

// Выполнить команду/действие в режиме 1С:Предприятия
//
// Параметры:
//   ПараметрЗапуска - <Строка> - <описание параметра>
//   ОбработкаДляЗапуска - <Строка> - <описание параметра>
//   ТолстыйКлиент - <Булево> - признак запуска толстого клиента
//   ДополнительныеКлючиЗапуска - <Строка> - <описание параметра>
//   ОжидатьЗавершения - Булево - по умолчанию Истина, Ложь - запускает и завершает свой процесс.
//
Процедура ЗапуститьВРежимеПредприятия(Знач ПараметрЗапуска="",
										Знач ОбработкаДляЗапуска="", Знач ТолстыйКлиент = Ложь,
										Знач ДополнительныеКлючиЗапуска = "",
										Знач ОжидатьЗавершения = Истина) Экспорт

	Лог.Информация("Выполняю команду/действие в режиме 1С:Предприятие");

	ТекущаяПроцедура = "ЗапуститьВРежимеПредприятия";
					
	Если Не ТолстыйКлиент Тогда
		ТонкийКлиент1С = УправлениеКонфигуратором.ПутьКТонкомуКлиенту1С(УправлениеКонфигуратором.ПутьКПлатформе1С());
		УправлениеКонфигуратором.ПутьКПлатформе1С(ТонкийКлиент1С);
	КонецЕсли;
	
	УправлениеКонфигуратором.УстановитьПризнакОжиданияВыполненияПрограммы(ОжидатьЗавершения);

	Если Не ОжидатьЗавершения Тогда
		МенеджерВременныхФайлов = Новый МенеджерВременныхФайлов;
		УправлениеКонфигуратором.УстановитьИмяФайлаСообщенийПлатформы(ВременныеФайлы.НовоеИмяФайла());
		МенеджерВременныхФайлов = Неопределено;
	КонецЕсли;

	ДополнительныеКлючи = ДополнительныеКлючиЗапуска;
	Если Не ПустаяСтрока(ОбработкаДляЗапуска) Тогда
		ДополнительныеКлючи = "" + ДополнительныеКлючи + " /Execute"+ОбщиеМетоды.ОбернутьПутьВКавычки(ОбработкаДляЗапуска);
	КонецЕсли;
	
	Лог.Отладка("ДополнительныеКлючи:"+ДополнительныеКлючи);
	Лог.Отладка("ПараметрЗапуска:"+ПараметрЗапуска);
	
	Попытка
		УправлениеКонфигуратором.ЗапуститьВРежимеПредприятия(ПараметрЗапуска, Не ТолстыйКлиент, ДополнительныеКлючи);
		Текст = УправлениеКонфигуратором.ВыводКоманды();
		Если Не ПустаяСтрока(Текст) Тогда
			Лог.Информация(Текст);
		КонецЕсли;

	Исключение
		Лог.Ошибка(УправлениеКонфигуратором.ВыводКоманды());
		ВызватьИсключение ТекущаяПроцедура;
	КонецПопытки;

	Лог.Информация("Выполнение команды/действие в режиме 1С:Предприятие завершено.");
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//   СтрокаПодключенияХранилище - <Тип.Вид> - <описание параметра>
//   ПользовательХранилища - <Тип.Вид> - <описание параметра>
//   ПарольХранилища - <Тип.Вид> - <описание параметра>
//   ВерсияХранилища - <Тип.Вид> - <описание параметра>
//   ДополнительныеКлючиЗапуска - <Тип.Вид> - <описание параметра>
//
Процедура ЗапуститьОбновлениеИзХранилища(
			Знач СтрокаПодключенияХранилище = "", Знач ПользовательХранилища="", Знач ПарольХранилища="",
			Знач ВерсияХранилища = "", Знач ДополнительныеКлючиЗапуска = "") Экспорт

	Лог.Информация("Выполняю обновление конфигурации из хранилища");

	ТекущаяПроцедура = "ЗапуститьОбновлениеИзХранилища";

	Ожидаем.Что(СтрокаПодключенияХранилище, ТекущаяПроцедура+" не задана строка подключения к хранилищу").Заполнено();
	Ожидаем.Что(ПользовательХранилища, ТекущаяПроцедура+" не задан пользователь хранилища").Заполнено();
	
	Параметры = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();

	Параметры.Добавить("/ConfigurationRepositoryF """+СтрокаПодключенияХранилище+"""");
	Параметры.Добавить("/ConfigurationRepositoryN """+ПользовательХранилища+"""");

	Если Не ПустаяСтрока(ПарольХранилища) Тогда
		Параметры.Добавить("/ConfigurationRepositoryP """+ПарольХранилища+"""");
	КонецЕсли;

	Параметры.Добавить("/ConfigurationRepositoryUpdateCfg"); 
	Параметры.Добавить("-force");
	Если Не ПустаяСтрока(ВерсияХранилища) Тогда
		Параметры.Добавить("-v" + ВерсияХранилища);
	КонецЕсли;
	
	Если Не ПустаяСтрока(ДополнительныеКлючиЗапуска) Тогда
		Параметры.Добавить(ДополнительныеКлючиЗапуска);
	КонецЕсли;

	Попытка
		УправлениеКонфигуратором.ВыполнитьКоманду(Параметры);
		Текст = УправлениеКонфигуратором.ВыводКоманды();
		Если Не ПустаяСтрока(Текст) Тогда
			Лог.Информация(Текст);
		КонецЕсли;

		Лог.Информация("Обновление конфигурации из хранилища завершено");
	Исключение
		Лог.Ошибка(УправлениеКонфигуратором.ВыводКоманды());
		ВызватьИсключение ТекущаяПроцедура;
	КонецПопытки;

КонецПроцедуры //ЗапуститьОбновлениеИзХранилища

// Выгружает файл конфигурации из ИБ
//
// Параметры:
//  ПутьКНужномуФайлуКонфигурации - Строка - Путь к результату - выгружаемому файлу конфигурации (*.cf)
//
Процедура ВыгрузитьКонфигурациюВФайл(Знач ПутьКНужномуФайлуКонфигурации) Экспорт

	Лог.Информация("Запускаю выгрузку конфигурации в файл");
	ТекущаяПроцедура = "ВыгрузитьКонфигурациюВФайл";
	
	Попытка
		УправлениеКонфигуратором.ВыгрузитьКонфигурациюВФайл(ПутьКНужномуФайлуКонфигурации);
		Текст = УправлениеКонфигуратором.ВыводКоманды();
		Если Не ПустаяСтрока(Текст) Тогда
			Лог.Информация(Текст);
		КонецЕсли;
	Исключение
		Лог.Ошибка(УправлениеКонфигуратором.ВыводКоманды());
		ВызватьИсключение ТекущаяПроцедура;
	КонецПопытки;

	Лог.Информация("Выгрузка в файл завершена.");

КонецПроцедуры //ВыгрузитьКонфигурациюВФайл

Функция ВыполнитьСинтаксическийКонтроль(Знач КоллекцияПроверок,
	РезультатПроверки) Экспорт

	Лог.Информация("Выполняю синтакс-контроль конфигурации");
	ТекущаяПроцедура = "ВыполнитьСинтаксическийКонтроль";

	РезультатПроверки = "";
	Успешно = ПолучитьРезультатыСинтаксическогоКонтроля(УправлениеКонфигуратором, КоллекцияПроверок, РезультатПроверки);

	Лог.Информация("Результат синтакс-контроля: %1", РезультатПроверки);

	Возврат Успешно;
	
КонецФункции

Процедура СобратьИзИсходниковТекущуюКонфигурацию(Знач ВходнойКаталог, 
	Знач СписокФайловДляЗагрузки = "", СниматьСПоддержки = Ложь, ОбновитьФайлВерсий = Истина) Экспорт
	Перем НеобходимоОбновлять, ИмяВременногоФайла;
	Лог.Информация("Загрузка конфигурации из файлов " + ВходнойКаталог);
	НеобходимоОбновлять = Ложь;
	КаталогВыгрузки = Новый Файл(ВходнойКаталог); 
	Если КаталогВыгрузки.Существует() = Ложь Тогда
		ВызватьИсключение СтроковыеФункции.ПодставитьПараметрыВСтроку("Каталог исходников %1 не найден", КаталогВыгрузки.ПолноеИмя);
	КонецЕсли;

	ФайлПереименований = Новый Файл(ОбъединитьПути(ВходнойКаталог, "renames.txt"));
	Если ФайлПереименованийВалиден(ФайлПереименований) Тогда 
		КаталогЗагрузки = ПодготовитьКаталогЗагрузкиПоФайлуПереименований(ВходнойКаталог, ФайлПереименований.ПолноеИмя);
	Иначе
		КаталогЗагрузки = ВходнойКаталог;
	КонецЕсли;

	Конфигуратор = УправлениеКонфигуратором();
	
	Если СниматьСПоддержки = Истина Тогда
		ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
		ПараметрыЗапуска.Добавить("/ConfigurationRepositoryUnbindCfg -force");
		Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);

		ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
		ПараметрыЗапуска.Добавить("/ManageCfgSupport -disableSupport -force");
		Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);

	КонецЕсли;

	ИмяВременногоФайла = "";
	Если ЗначениеЗаполнено(СписокФайловДляЗагрузки) Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
		Запись = Новый ЗаписьТекста(ИмяВременногоФайла);
		Запись.Записать(СписокФайловДляЗагрузки);
		Запись.Закрыть();
	КонецЕсли;

	Конфигуратор.ЗагрузитьКонфигурациюИзФайлов(КаталогЗагрузки, ИмяВременногоФайла, , ОбновитьФайлВерсий);

	Если НеобходимоОбновлять Тогда
		Конфигуратор.ОбновитьКонфигурациюБазыДанных(Ложь, Истина);
	КонецЕсли;
	
	Лог.Информация("Загрузка конфигурации из файлов успешно завершена!");
	
КонецПроцедуры //СобратьИзИсходниковТекущуюКонфигурацию

// { приватная часть 

Функция ПолучитьРезультатыСинтаксическогоКонтроля(Знач Конфигуратор, Знач КоллекцияПроверок, ЛогПроверкиИзКонфигуратора)
	Ключи = ПолучитьКлючиПроверкиКонфигурации(КоллекцияПроверок);

	Успешно = Истина;
	Попытка
		Конфигуратор.ВыполнитьРасширеннуюПроверкуКонфигуратора(Ключи);
		ЛогПроверкиИзКонфигуратора = Конфигуратор.ВыводКоманды();
	Исключение
		ЛогПроверкиИзКонфигуратора = Конфигуратор.ВыводКоманды();
		Успешно = Ложь;		
	КонецПопытки;
	
	
	Возврат Успешно;
	
КонецФункции

Функция ПолучитьКлючиПроверкиКонфигурации(Знач КоллекцияПроверок)
	
	Ключи = Новый Соответствие;
	Если КоллекцияПроверок = Неопределено Тогда
		Ключи.Вставить("-ThinClient", Истина);
		Ключи.Вставить("-WebClient", Истина);
		Ключи.Вставить("-Server", Истина);
		Ключи.Вставить("-ExternalConnection", Истина);
		Ключи.Вставить("-ThickClientOrdinaryApplication", Истина);
	Иначе
		Для каждого Ключ Из КоллекцияПроверок Цикл
			Если Ключ = "--mode" Тогда
				Продолжить;
			КонецЕсли;			
			Ключи.Вставить(Ключ, Истина);
		КонецЦикла;
	КонецЕсли;

	Возврат Ключи;
	
КонецФункции

Функция ПолучитьЛог()
	Если Лог = Неопределено Тогда
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецЕсли;
	Возврат Лог;	
КонецФункции

Функция ПодготовитьКаталогЗагрузкиПоФайлуПереименований(ВходнойКаталог, ФайлПереименований)
	Перем БылаОшибка;
	КаталогВременнойСтруктуры = ВременныеФайлы.СоздатьКаталог();
	Текст = Новый ЧтениеТекста(ФайлПереименований);
	СоответствиеФайлов = Новый Соответствие();
	БылаОшибка = Ложь;
	Стр = Текст.ПрочитатьСтроку();
	Пока Стр <> Неопределено Цикл // строки читаются до символа перевода строки
		Если ПараметрыСистемы.ЭтоWindows = Ложь Тогда 
			Стр = СтрЗаменить(Стр, "\", "/");
		КонецЕсли;
		
		Индекс = Найти(Стр, "-->");
		Если Индекс > 0 Тогда
			ИмяНовогоФайла = ОбъединитьПути(КаталогВременнойСтруктуры, Лев(Стр, Индекс-1));
			ФайлНовый = Новый Файл(ИмяНовогоФайла); 
			КаталогНовый = Новый Файл(ФайлНовый.Путь);
			Если НЕ КаталогНовый.Существует() Тогда 
				СоздатьКаталог(ФайлНовый.Путь);
			КонецЕсли;
			ПутьФайлСтарый = ОбъединитьПути(ВходнойКаталог, Сред(Стр, Индекс+3));
			ФайлСтарый = Новый Файл(ПутьФайлСтарый);
			Если ФайлСтарый.Существует() Тогда
				СоответствиеФайлов.Вставить(ФайлСтарый.ПолноеИмя, Истина);
				КопироватьФайл(ПутьФайлСтарый, ИмяНовогоФайла);
				Если Нрег(Прав(ФайлНовый.ПолноеИмя, 5)) = ".form" Или Нрег(ФайлНовый.Имя) = "form.bin" Тогда
					КаталогФормыСтарый = ОбъединитьПути(ФайлСтарый.Путь, ФайлНовый.ИмяБезРасширения);
					КаталогФормыНовый = ОбъединитьПути(ФайлНовый.Путь, ФайлНовый.ИмяБезРасширения);
					СоздатьКаталог(КаталогФормыНовый);
					МассивФайлов = НайтиФайлы(КаталогФормыСтарый, ПолучитьМаскуВсеФайлы());
					Для Каждого Элемент из МассивФайлов Цикл
						Лог.Отладка("Копируем "+Элемент.ПолноеИмя + "--> "+ОбъединитьПути(КаталогФормыНовый, Элемент.Имя)); 
						КопироватьФайл(Элемент.ПолноеИмя, ОбъединитьПути(КаталогФормыНовый, Элемент.Имя));
					КонецЦикла;
					
					УпаковщикМетаданных.УпаковатьКонтейнерМетаданных(КаталогФормыНовый, ФайлНовый.ПолноеИмя);
				КонецЕсли;
			Иначе
				БылаОшибка = Истина;	
			КонецЕсли;
		КонецЕсли;
		
		Стр = Текст.ПрочитатьСтроку();
		
	КонецЦикла;

	Если БылаОшибка = Истина Тогда
		МассивФайлов = НайтиФайлы(ВходнойКаталог, ПолучитьМаскуВсеФайлы(), Истина);
		Для Каждого Элемент из МассивФайлов Цикл 
			Если СоответствиеФайлов.Получить(Элемент.ПолноеИмя) = Неопределено Тогда 
				ИмяНовогоФайла = ОбъединитьПути(КаталогВременнойСтруктуры, Сред(Элемент.ПолноеИмя, СтрДлина(ВходнойКаталог)));
				ФайлНовый = Новый Файл(ИмяНовогоФайла);
				КаталогНовый = Новый Файл(ФайлНовый.Путь);
				Если НЕ КаталогНовый.Существует() Тогда 
					СоздатьКаталог(ФайлНовый.Путь);
				КонецЕсли;
				КопироватьФайл(Элемент.ПолноеИмя, ИмяНовогоФайла);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат КаталогВременнойСтруктуры;
	
КонецФункции

Функция ФайлПереименованийВалиден(Знач ФайлПереименований)
	Рез = Ложь;
	Если ФайлПереименований.Существует() Тогда
		ПутьВыгрузки = ФайлПереименований.Путь;
		ФайлКонфигурации = Новый Файл(ОбъединитьПути(ПутьВыгрузки, "Configuration.xml"));
		Если ФайлКонфигурации.ПолучитьВремяИзменения() <= ФайлПереименований.ПолучитьВремяИзменения() Тогда
			Рез = Истина;

			Лог.Отладка("Файл конфигурации %1 создан не позже файла переименований %2", 
				ФайлКонфигурации.Имя, ФайлПереименований.Имя);
			Лог.Отладка("Данные о переименованиях использовать можно.");
		Иначе
			Лог.Отладка("Файл конфигурации %1 создан позже файла переименований %2", 
				ФайлКонфигурации.Имя, ФайлПереименований.Имя);
			Лог.Отладка("	Дата/время файла конфигурации %1 - %2", 
				ФайлКонфигурации.Имя, ФайлКонфигурации.ПолучитьВремяИзменения());
			Лог.Отладка("	Дата/время файла переименований %1 - %2", 
				ФайлПереименований.Имя, ФайлПереименований.ПолучитьВремяИзменения());
			Лог.Отладка("Файл переименований использовать нельзя, использую только штатную загрузку через Конфигуратор.");
		КонецЕсли;
	Иначе
		Лог.Отладка("Файл переименований %1 не существует, использую только штатную загрузку через Конфигуратор.",
			ФайлПереименований.Имя);
	КонецЕсли;
	Возврат Рез;
КонецФункции

// }

ПолучитьЛог();
