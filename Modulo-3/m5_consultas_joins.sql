USE Ventas_Tech_DB;
GO

-- Consulta 1: Vista base de ventas (INNER JOIN)
-- Proposito: ver cada venta con el cliente, producto y categoria.
-- La ciudad del cliente sirve para agrupar o filtrar en Power BI.
SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS cliente,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;
-- Hallazgo: las 10 ventas tienen cliente, producto y categoria asociados.
-- En total se facturaron 6444.00 durante marzo de 2024.

-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Proposito: encontrar clientes registrados que todavia no compraron.
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
-- Hallazgo: aparecen 0 clientes sin compras. Con estos datos,
-- CRM no tiene clientes pendientes de su primera compra.

-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Proposito: revisar si hay articulos del catalogo sin movimiento.
SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;
-- Hallazgo: aparecen 0 productos sin ventas. Los 6 productos
-- tuvieron movimiento, por lo que no se detectan articulos sin vender.

-- Consulta 4: Consolidado por canal (UNION ALL)
-- Proposito: comparar dos grupos de ventas segun la fecha.
-- Como la base no tiene un canal real, usamos dos periodos de marzo
-- y les damos nombres distintos para practicar UNION ALL.
SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Primera mitad (1 al 10)' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-01' AND fecha_venta < '2024-03-11'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Segunda mitad (11 al 31)' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-11' AND fecha_venta < '2024-04-01'
) AS consolidado
GROUP BY canal
ORDER BY canal;
-- Hallazgo: del 1 al 10 de marzo se facturaron 3620.00 y del 11 al 31,
-- 2824.00. La primera parte del mes genero mas ingresos.
