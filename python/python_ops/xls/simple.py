#coding: utf-8
import xlsxwriter
workbook = xlsxwriter.Workbook('demo1.xlsx') # 创建一个 Excel 文件
worksheet = workbook.add_worksheet() # 创建一个工作表对象 worksheet.set_column('A:A', 20) # 设定第一列(A)宽度为 20 像素
bold = workbook.add_format({'bold': True}) # 定义一个加粗的格式对象
worksheet.write('A1', 'Hello') #A1 单元格写入 'Hello'
worksheet.write('A2', 'World', bold) #A2 单元格写入 'World' 并引用加粗格式对象 bold worksheet.write('B2', u' 中文测试 ', bold) #B2 单元格写入中文并引用加粗格式对象 bold
worksheet.write(2, 0, 32) # 用行列表示法写入数字 '32' 与 '35.5' worksheet.write(3, 0, 35.5) # 行列表示法的单元格下标以 0 作为起始值,'3,0' 等价于 'A3' worksheet.write(4, 0, '=SUM(A3:A4)') # 求 A3:A4 的和,并将结果写入 '4,0',即 'A5'
worksheet.insert_image('B5', 'img/docker-logo.png') # 在 B5 单元格插入图片 workbook.close() # 关闭 Excel 文件

worksheet.write(6, 0, 'Hello') 
worksheet.write(7, 0, 'World') 
worksheet.write(8, 0, 2) 
worksheet.write(9, 0, 3.00001) 
worksheet.write(10, 0, '=SIN(PI()/4)') 
worksheet.write(11, 0, '') 
worksheet.write(12, 0, None)

worksheet.write('A12', 'Hello') # 在 A1 单元格写入 'Hellow' 字符串
cell_format = workbook.add_format({'bold': True}) # 定义一个加粗的格式对象 
worksheet.set_row(14, 40, cell_format) # 设置第 1 行单元格高度为 40 像素,且引用加粗
# 格式对象 
worksheet.set_row(15, None, None, {'hidden': True}) # 隐藏第 2 行单元格



workbook.close() # 关闭 Excel 文件