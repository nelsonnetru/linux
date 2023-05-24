#!/bin/bash

if [ -z $1 ]
 then
   echo "Ошибка! Не указана директория"
   exit 1
fi

dir=$1

if [ -d "${dir}" ]
  then
    #выберем всех уникальных владельцев директорий и в цикле создадим для каждого свою директорию
    for i in $(ls -l "${dir}" | awk '{print $3}' | sort | uniq)
     do
	if [ -d "${dir}/${i}" ]
	  then
	    echo "Директория для владельца ${i} существует"
	  else
	    echo "Создание директории для владельца: ${i}"
	    mkdir "${dir}/${i}"
	fi
     done

cd $dir

    #переберем все файлы в заданной директории и скопируем каждый из них в папку с именем владельца
    for file in *
      do
	if [ -f "${file}" ]
	 then
	   ownerdir=$(ls -l "${file}" | awk '{print $3'})
	   #копируем с ключом -p для сохранения всех аттрибутов
	   cp -p "${file}" "./${ownerdir}/${file}"
	   echo "Копирование ${file} -> ./${ownerdir}/${file}" 
	fi
      done
      echo "Копирование завершено"
  else
    echo "Ошибка! Директория ${dir} не существует"
    exit 1
fi
