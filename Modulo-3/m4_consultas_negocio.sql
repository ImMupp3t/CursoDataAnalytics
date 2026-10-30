USE Ventas_Tech_DB;
GO

-- CONSULTA 1: Resumen mensual de ventas
-- Agrupo las ventas por mes para ver cuanto se facturo y el ticket promedio.
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- CONSULTA 2: Los 5 productos que mas facturaron
-- Por ahora uso el ID del producto, ya que los JOIN se ven en el siguiente modulo.
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- CONSULTA 3: Clientes que compraron mas de una vez
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

-- CONSULTA 4: Comparacion con el promedio de facturacion por producto
-- Primero calculo cuanto facturo cada producto y despues comparo esos totales.
WITH facturacion_productos AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_productos)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_productos
ORDER BY total_facturado DESC;

-- HALLAZGOS (con los datos cargados en el Modulo 3)
-- 1. En marzo de 2024 se registraron 10 pedidos por un total de 6444.00.
--    El ticket promedio fue de 644.40.
-- 2. El producto con ID 1 fue el de mayor facturacion: 3600.00,
--    aproximadamente el 55.9% del total vendido.
-- 3. Los cinco clientes hicieron mas de un pedido. Ademas, solo los
--    productos 1 y 3 superaron el promedio de 1074.00 por producto.
