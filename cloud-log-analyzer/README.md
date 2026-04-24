# Práctica 4.2 — Variante B: Código HTTP más frecuente

## Descripción
Programa en ARM64 Assembly que lee códigos de estado HTTP desde stdin
y determina cuál aparece con mayor frecuencia.

## Diseño y lógica

1. **Inicialización**: El array `freq` de 500 entradas (4 bytes c/u) se
   pone a cero manualmente usando un loop con `str wzr`.

2. **Lectura**: Syscall `read` (x8=63) lee stdin en bloques de 4096 bytes.
   El loop se repite hasta recibir EOF (retorno = 0).

3. **Parseo**: Se recorre el buffer byte a byte. Al encontrar 3 dígitos
   ASCII consecutivos se reconstruye el número entero multiplicando por
   potencias de 10.

4. **Conteo**: Si el código está en rango 100–599 se incrementa
   `freq[código - 100]`. El offset en bytes se calcula con shift left 2
   (equivalente a multiplicar por 4).

5. **Máximo**: Se escanea `freq[]` completo guardando el índice con el
   valor más alto.

6. **Salida**: Se imprime el mensaje fijo y el código convertido a ASCII
   dígito por dígito usando `udiv` y `msub`.

## Syscalls Linux ARM64 utilizadas

| Nombre | Número | Uso               |
|--------|--------|-------------------|
| read   | 63     | Leer stdin        |
| write  | 64     | Imprimir resultado|
| exit   | 93     | Terminar proceso  |

## Compilación

```bash
make
```

## Ejecución

```bash
cat logs_B.txt | ./analyzer
```

## Prueba manual

```bash
printf "200\n200\n404\n200\n500\n" | ./analyzer
```

Salida esperada: `Most frequent status code: 200`