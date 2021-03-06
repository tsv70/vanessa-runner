///////////////////////////////////////////////////////////////////
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями 
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания = 
		"     Сборка внешних обработок из исходников штатно через выгрузку 1С 8.3.";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписания);

	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "inputPath", "Путь к каталогу или внешней обработке
	|
	|Схема работы:
	|		В каталоге выгрузки создается отдельный подкаталог для каждой внешней обработки
	|		Сохраняется структура подкаталогов, если выгружается каталог.
	|");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "outputPath", "Путь бинарников");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cachekey",
		"Ключ кэшированных значений файлов, default: compileepfrunner");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--onlycopy",
		"Флаг, только копировать. Без сборки обработки, даже если выглядит как обработка");
	

	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	УпаковщикВнешнихОбработок = Новый УпаковщикВнешнихОбработок;
	УпаковщикВнешнихОбработок.УстановитьЛог(ДополнительныеПараметры.Лог);

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];
	
	УпаковщикВнешнихОбработок.Собрать(
		ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["inputPath"]), 
		ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["outputPath"]),
		ДанныеПодключения.СтрокаПодключения, ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль, 
		ПараметрыКоманды["--v8version"],
		ПараметрыКоманды["--onlycopy"],
		ПараметрыКоманды["--cachekey"]);

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду
